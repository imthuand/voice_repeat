import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../domain/constants.dart';
import '../db/app_db.dart';
import '../ids.dart';

enum RitualEventType {
  recorded,
  played,
  archived,
  restored,
  deleted,
  renamed,
}

extension RitualEventTypeName on RitualEventType {
  String get eventName {
    switch (this) {
      case RitualEventType.recorded:
        return RitualEventName.recorded;
      case RitualEventType.played:
        return RitualEventName.played;
      case RitualEventType.archived:
        return RitualEventName.archived;
      case RitualEventType.restored:
        return RitualEventName.restored;
      case RitualEventType.deleted:
        return RitualEventName.deleted;
      case RitualEventType.renamed:
        return RitualEventName.renamed;
    }
  }
}

class RitualRepo {
  RitualRepo(
    this.db, {
    this.enforcementMode = EnforcementMode.soft,
  });

  final AppDb db;
  final String enforcementMode;

  int _now() => DateTime.now().millisecondsSinceEpoch;

  static const String stateEmpty = ItemState.empty;
  static const String stateRecorded = ItemState.recorded;
  static const String stateArchived = ItemState.archived;

  static const String integrityOk = IntegrityStatus.ok;
  static const String integrityMissingPath = IntegrityStatus.missingPath;
  static const String integrityMissingFile = IntegrityStatus.missingFile;

  bool get isStrict => enforcementMode == EnforcementMode.strict;

  String _normalizeSearchText(String s) => s.trim().toLowerCase();

  void _ensureState(String actual, Set<String> allowed, String action) {
    if (!allowed.contains(actual)) {
      throw StateError('Invalid state for $action: $actual');
    }
  }

  void _requireNonEmptyPath(String path, String action, String fieldName) {
    if (path.trim().isEmpty) {
      throw StateError('Invalid $action: $fieldName must not be empty');
    }
  }

  void _requirePositiveSize(int sizeBytes, String action) {
    if (sizeBytes <= 0) {
      throw StateError('Invalid $action: sizeBytes must be greater than zero');
    }
  }

  Future<String> ensureDefaultPerson() async {
    final existing = await db.select(db.persons).get();
    if (existing.isNotEmpty) return existing.first.personId;

    final now = _now();
    const id = 'family';

    await db.into(db.persons).insert(
          PersonsCompanion.insert(
            personId: id,
            displayName: 'Family',
            role: 'family',
            language: const Value('de'),
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );

    return id;
  }

  Future<void> ensureInitialSlots(String personId, {int initial = 4}) async {
    final now = _now();

    await db.transaction(() async {
      for (var slot = 0; slot < initial; slot++) {
        final exists = await (db.select(db.ritualItems)
              ..where((t) => t.personId.equals(personId) & t.slotIndex.equals(slot)))
            .getSingleOrNull();

        if (exists != null) continue;

        await db.into(db.ritualItems).insert(
              RitualItemsCompanion.insert(
                itemId: Ids.v4(),
                personId: personId,
                slotIndex: slot,
                createdAt: now,
                updatedAt: now,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }

      await _ensureAtLeastOneEmptyTx(personId);
    });
  }

  Future<void> ensureAtLeastOneEmpty(String personId) async {
    await db.transaction(() async {
      await _ensureAtLeastOneEmptyTx(personId);
    });
  }

  Future<void> _ensureAtLeastOneEmptyTx(String personId) async {
    final items = await (db.select(db.ritualItems)..where((t) => t.personId.equals(personId))).get();
    final hasEmpty = items.any((x) => x.state == stateEmpty);
    if (hasEmpty) return;

    final nextSlot = (items.map((e) => e.slotIndex).fold<int>(-1, max)) + 1;
    final now = _now();

    await db.into(db.ritualItems).insert(
          RitualItemsCompanion.insert(
            itemId: Ids.v4(),
            personId: personId,
            slotIndex: nextSlot,
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Stream<List<RitualItem>> watchActive(String personId) {
    return (db.select(db.ritualItems)
          ..where((t) => t.personId.equals(personId) & t.state.isNotValue(stateArchived))
          ..orderBy([(t) => OrderingTerm(expression: t.slotIndex)]))
        .watch();
  }

  Stream<List<RitualItem>> watchArchived(String personId) {
    return (db.select(db.ritualItems)
          ..where((t) => t.personId.equals(personId) & t.state.equals(stateArchived))
          ..orderBy([
            (t) => OrderingTerm(expression: t.archivedAt, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<RitualItem> _getByIdTx(String itemId) {
    return (db.select(db.ritualItems)..where((t) => t.itemId.equals(itemId))).getSingle();
  }

  Future<void> logEvent({
    required String personId,
    required String itemId,
    required RitualEventType type,
    Map<String, dynamic>? metadata,
  }) async {
    final now = _now();

    RitualItem? it;
    try {
      it = await (db.select(db.ritualItems)..where((t) => t.itemId.equals(itemId))).getSingleOrNull();
    } catch (_) {}

    final computedPath = (it?.state == stateArchived) ? it?.archivedPath : it?.activePath;

    final sleeve = it?.sleeveId ?? 'default';
    final slotValue = it?.slotIndex ?? -1;
    final stateValue = it?.state ?? '';
    final pathValue = computedPath ?? '';
    final sizeValue = it?.sizeBytes ?? 0;

    await db.into(db.ritualEvents).insert(
          RitualEventsCompanion(
            eventId: Value(Ids.v4()),
            itemId: Value(itemId),
            personId: Value(personId),
            eventType: Value(type.eventName),
            timestamp: Value(now),
            metadata: metadata == null ? const Value(null) : Value(jsonEncode(metadata)),
            sleeveId: Value(sleeve),
            slotIndex: Value(slotValue),
            itemState: Value(stateValue),
            path: Value(pathValue),
            sizeBytes: Value(sizeValue),
            source: const Value(EventSource.repo),
            enforcementMode: Value(enforcementMode),
          ),
        );
  }

  Future<void> rename({
    required String personId,
    required String itemId,
    required String label,
  }) async {
    final now = _now();

    await db.transaction(() async {
      final it = await _getByIdTx(itemId);
      _ensureState(it.state, {stateEmpty, stateRecorded, stateArchived}, 'rename');

      final search = _normalizeSearchText(label);

      await (db.update(db.ritualItems)..where((t) => t.itemId.equals(itemId))).write(
        RitualItemsCompanion(
          label: Value(label),
          searchText: Value(search),
          integrityCheckedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await logEvent(
        personId: personId,
        itemId: itemId,
        type: RitualEventType.renamed,
        metadata: {'label': label},
      );
    });
  }

  Future<void> setRecorded({
    required String personId,
    required String itemId,
    required String label,
    required String activePath,
    required int sizeBytes,
  }) async {
    final now = _now();

    if (isStrict) {
      _requireNonEmptyPath(activePath, 'setRecorded', 'activePath');
      _requirePositiveSize(sizeBytes, 'setRecorded');
    }

    await db.transaction(() async {
      final it = await _getByIdTx(itemId);
      _ensureState(it.state, {stateEmpty, stateArchived, stateRecorded}, 'setRecorded');

      final effectiveLabel = label.isEmpty ? it.label : label;
      final search = _normalizeSearchText(effectiveLabel);

      await (db.update(db.ritualItems)..where((t) => t.itemId.equals(itemId))).write(
        RitualItemsCompanion(
          label: Value(effectiveLabel),
          searchText: Value(search),
          state: const Value(stateRecorded),
          activePath: Value(activePath),
          archivedPath: const Value(null),
          sizeBytes: Value(sizeBytes),
          recordedAt: Value(now),
          archivedAt: const Value(null),
          integrityStatus: const Value(integrityOk),
          integrityCheckedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await logEvent(
        personId: personId,
        itemId: itemId,
        type: RitualEventType.recorded,
        metadata: {'sizeBytes': sizeBytes},
      );

      await _ensureAtLeastOneEmptyTx(personId);
    });
  }

  Future<void> markPlayed({
    required String personId,
    required String itemId,
  }) async {
    final now = _now();

    await db.transaction(() async {
      final it = await _getByIdTx(itemId);
      _ensureState(it.state, {stateRecorded, stateArchived}, 'markPlayed');

      await (db.update(db.ritualItems)..where((t) => t.itemId.equals(itemId))).write(
        RitualItemsCompanion(
          usageCountTotal: Value(it.usageCountTotal + 1),
          lastUsedAt: Value(now),
          integrityCheckedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await logEvent(
        personId: personId,
        itemId: itemId,
        type: RitualEventType.played,
      );
    });
  }

  Future<void> setArchived({
    required String personId,
    required String itemId,
    required String archivedPath,
  }) async {
    final now = _now();

    if (isStrict) {
      _requireNonEmptyPath(archivedPath, 'setArchived', 'archivedPath');
    }

    await db.transaction(() async {
      final it = await _getByIdTx(itemId);
      _ensureState(it.state, {stateRecorded}, 'setArchived');

      await (db.update(db.ritualItems)..where((t) => t.itemId.equals(itemId))).write(
        RitualItemsCompanion(
          state: const Value(stateArchived),
          archivedPath: Value(archivedPath),
          activePath: const Value(null),
          archivedAt: Value(now),
          integrityStatus: const Value(integrityOk),
          integrityCheckedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await logEvent(
        personId: personId,
        itemId: itemId,
        type: RitualEventType.archived,
      );

      await _ensureAtLeastOneEmptyTx(personId);
    });
  }

  Future<void> restore({
    required String personId,
    required String itemId,
    required String activePath,
  }) async {
    final now = _now();

    if (isStrict) {
      _requireNonEmptyPath(activePath, 'restore', 'activePath');
    }

    await db.transaction(() async {
      final it = await _getByIdTx(itemId);
      _ensureState(it.state, {stateArchived}, 'restore');

      await (db.update(db.ritualItems)..where((t) => t.itemId.equals(itemId))).write(
        RitualItemsCompanion(
          state: const Value(stateRecorded),
          activePath: Value(activePath),
          archivedPath: const Value(null),
          recordedAt: Value(now),
          archivedAt: const Value(null),
          integrityStatus: const Value(integrityOk),
          integrityCheckedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await logEvent(
        personId: personId,
        itemId: itemId,
        type: RitualEventType.restored,
      );

      await _ensureAtLeastOneEmptyTx(personId);
    });
  }

  Future<void> clearToEmpty({
    required String personId,
    required String itemId,
  }) async {
    final now = _now();

    await db.transaction(() async {
      final it = await _getByIdTx(itemId);
      _ensureState(it.state, {stateEmpty, stateRecorded, stateArchived}, 'clearToEmpty');

      await (db.update(db.ritualItems)..where((t) => t.itemId.equals(itemId))).write(
        RitualItemsCompanion(
          state: const Value(stateEmpty),
          label: const Value(''),
          searchText: const Value(''),
          activePath: const Value(null),
          archivedPath: const Value(null),
          sizeBytes: const Value(0),
          usageCountTotal: const Value(0),
          lastUsedAt: const Value(null),
          recordedAt: const Value(null),
          archivedAt: const Value(null),
          integrityStatus: const Value(integrityOk),
          integrityCheckedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await logEvent(
        personId: personId,
        itemId: itemId,
        type: RitualEventType.deleted,
        metadata: {'mode': 'clear'},
      );

      await _ensureAtLeastOneEmptyTx(personId);
    });
  }

  Future<void> deleteSlot({
    required String personId,
    required String itemId,
  }) async {
    await db.transaction(() async {
      final it = await _getByIdTx(itemId);
      _ensureState(it.state, {stateEmpty, stateRecorded, stateArchived}, 'deleteSlot');

      await logEvent(
        personId: personId,
        itemId: itemId,
        type: RitualEventType.deleted,
        metadata: {
          'mode': 'slot',
          'prevState': it.state,
          'slotIndex': it.slotIndex,
        },
      );

      await (db.delete(db.ritualItems)..where((t) => t.itemId.equals(itemId))).go();

      await _ensureAtLeastOneEmptyTx(personId);
    });
  }
}