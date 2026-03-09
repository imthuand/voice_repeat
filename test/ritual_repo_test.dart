import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_repeat/data/db/app_db.dart';
import 'package:voice_repeat/data/repositories/ritual_repo.dart';
import 'package:voice_repeat/domain/constants.dart';

void main() {
  group('RitualRepo', () {
    late AppDb db;
    late RitualRepo repo;
    late String personId;
    late String sleeveId;

    setUp(() async {
      db = AppDb(executor: NativeDatabase.memory());
      repo = RitualRepo(db);
      personId = await repo.ensureDefaultPerson();
      await repo.ensureDefaultSleeve(personId);
      sleeveId = SleeveDefaults.defaultId;
      await repo.ensureInitialSlots(personId, initial: 4);
    });

    tearDown(() async {
      await db.close();
    });

    test('ensureDefaultPerson creates family person once', () async {
      final pid1 = await repo.ensureDefaultPerson();
      final pid2 = await repo.ensureDefaultPerson();

      expect(pid1, 'family');
      expect(pid2, 'family');

      final persons = await db.select(db.persons).get();
      expect(persons.length, 1);
      expect(persons.first.personId, 'family');
      expect(persons.first.displayName, 'Family');
    });

    test('ensureDefaultSleeve creates default sleeve once', () async {
      await repo.ensureDefaultSleeve(personId);
      await repo.ensureDefaultSleeve(personId);

      final sleeves = await (db.select(db.sleeves)
            ..where((t) => t.personId.equals(personId)))
          .get();

      expect(sleeves.length, 1);
      expect(sleeves.first.sleeveId, SleeveDefaults.defaultId);
      expect(sleeves.first.name, SleeveDefaults.defaultName);
    });

    test('ensureInitialSlots creates exactly N slots with unique slotIndex', () async {
      final items = await _itemsOfSleeve(db, personId, sleeveId);
      expect(items.length, 4);

      final slots = items.map((e) => e.slotIndex).toList()..sort();
      expect(slots, [0, 1, 2, 3]);

      expect(items.any((x) => x.state == RitualRepo.stateEmpty), true);
    });

    test('ensureAtLeastOneEmpty does nothing when an empty slot exists', () async {
      final before = await _itemsOfSleeve(db, personId, sleeveId);
      expect(before.any((x) => x.state == RitualRepo.stateEmpty), true);

      await repo.ensureAtLeastOneEmpty(personId, sleeveId: sleeveId);

      final after = await _itemsOfSleeve(db, personId, sleeveId);
      expect(after.length, before.length);
    });

    test('ensureAtLeastOneEmpty adds a new empty slot when none exist', () async {
      final items = await _itemsOfSleeve(db, personId, sleeveId);
      for (final it in items) {
        await repo.setRecorded(
          personId: personId,
          itemId: it.itemId,
          label: '',
          activePath: '/tmp/${it.slotIndex}.m4a',
          sizeBytes: 1,
        );
      }

      final after = await _itemsOfSleeve(db, personId, sleeveId);
      expect(after.length, 5);
      expect(after.any((x) => x.state == RitualRepo.stateEmpty), true);

      final maxSlot = after.map((e) => e.slotIndex).reduce((a, b) => a > b ? a : b);
      expect(maxSlot, 4);
    });

    test('createSleeve creates sleeve and one empty slot', () async {
      final newSleeveId = await repo.createSleeve(
        personId: personId,
        name: 'Morning',
      );

      final sleeves = await (db.select(db.sleeves)
            ..where((t) => t.personId.equals(personId)))
          .get();
      expect(sleeves.length, 2);

      final items = await _itemsOfSleeve(db, personId, newSleeveId);
      expect(items.length, 1);
      expect(items.single.state, RitualRepo.stateEmpty);
    });

    test('renameSleeve renames non default sleeve', () async {
      final newSleeveId = await repo.createSleeve(
        personId: personId,
        name: 'Morning',
      );

      await repo.renameSleeve(
        personId: personId,
        sleeveId: newSleeveId,
        name: 'Evening',
      );

      final sleeve = await (db.select(db.sleeves)
            ..where((t) => t.sleeveId.equals(newSleeveId)))
          .getSingle();
      expect(sleeve.name, 'Evening');
    });

    test('default sleeve cannot be renamed', () async {
      expect(
        () => repo.renameSleeve(
          personId: personId,
          sleeveId: SleeveDefaults.defaultId,
          name: 'Other',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('deleteSleeve only works when all items are empty and not default', () async {
      final newSleeveId = await repo.createSleeve(
        personId: personId,
        name: 'Morning',
      );

      await repo.deleteSleeve(
        personId: personId,
        sleeveId: newSleeveId,
      );

      final sleeves = await (db.select(db.sleeves)
            ..where((t) => t.personId.equals(personId)))
          .get();
      expect(sleeves.length, 1);
      expect(sleeves.single.sleeveId, SleeveDefaults.defaultId);
    });

    test('default sleeve cannot be deleted', () async {
      expect(
        () => repo.deleteSleeve(
          personId: personId,
          sleeveId: SleeveDefaults.defaultId,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('setRecorded: empty -> recorded, sets activePath and sizeBytes', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: 'Test',
        activePath: '/tmp/a.m4a',
        sizeBytes: 123,
      );

      final updated = await _byId(db, it.itemId);
      expect(updated.state, RitualRepo.stateRecorded);
      expect(updated.activePath, '/tmp/a.m4a');
      expect(updated.archivedPath, null);
      expect(updated.sizeBytes, 123);
      expect(updated.label, 'Test');
      expect(updated.recordedAt, isNotNull);
    });

    test('setRecorded overwrites recorded -> recorded (allowed)', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: 'A',
        activePath: '/tmp/a.m4a',
        sizeBytes: 10,
      );

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: 'B',
        activePath: '/tmp/b.m4a',
        sizeBytes: 20,
      );

      final updated = await _byId(db, it.itemId);
      expect(updated.state, RitualRepo.stateRecorded);
      expect(updated.activePath, '/tmp/b.m4a');
      expect(updated.sizeBytes, 20);
      expect(updated.label, 'B');
      expect(updated.recordedAt, isNotNull);
    });

    test('setArchived allowed only from recorded', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      expect(
        () => repo.setArchived(
          personId: personId,
          itemId: it.itemId,
          archivedPath: '/tmp/x.m4a',
        ),
        throwsA(isA<StateError>()),
      );

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: '',
        activePath: '/tmp/a.m4a',
        sizeBytes: 1,
      );

      await repo.setArchived(
        personId: personId,
        itemId: it.itemId,
        archivedPath: '/tmp/arch.m4a',
      );

      final updated = await _byId(db, it.itemId);
      expect(updated.state, RitualRepo.stateArchived);
      expect(updated.activePath, null);
      expect(updated.archivedPath, '/tmp/arch.m4a');
      expect(updated.archivedAt, isNotNull);
    });

    test('restore allowed only from archived', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      expect(
        () => repo.restore(
          personId: personId,
          itemId: it.itemId,
          activePath: '/tmp/a.m4a',
        ),
        throwsA(isA<StateError>()),
      );

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: '',
        activePath: '/tmp/a.m4a',
        sizeBytes: 1,
      );

      expect(
        () => repo.restore(
          personId: personId,
          itemId: it.itemId,
          activePath: '/tmp/a2.m4a',
        ),
        throwsA(isA<StateError>()),
      );

      await repo.setArchived(
        personId: personId,
        itemId: it.itemId,
        archivedPath: '/tmp/arch.m4a',
      );

      await repo.restore(
        personId: personId,
        itemId: it.itemId,
        activePath: '/tmp/a2.m4a',
      );

      final updated = await _byId(db, it.itemId);
      expect(updated.state, RitualRepo.stateRecorded);
      expect(updated.activePath, '/tmp/a2.m4a');
      expect(updated.archivedPath, null);
      expect(updated.recordedAt, isNotNull);
    });

    test('clearToEmpty resets fields for recorded', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: 'X',
        activePath: '/tmp/a.m4a',
        sizeBytes: 10,
      );

      await repo.markPlayed(personId: personId, itemId: it.itemId);
      await repo.clearToEmpty(personId: personId, itemId: it.itemId);

      final updated = await _byId(db, it.itemId);
      expect(updated.state, RitualRepo.stateEmpty);
      expect(updated.label, '');
      expect(updated.activePath, null);
      expect(updated.archivedPath, null);
      expect(updated.sizeBytes, 0);
      expect(updated.usageCountTotal, 0);
      expect(updated.lastUsedAt, null);
      expect(updated.recordedAt, null);
      expect(updated.archivedAt, null);
    });

    test('clearToEmpty resets fields for archived', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: '',
        activePath: '/tmp/a.m4a',
        sizeBytes: 1,
      );
      await repo.setArchived(
        personId: personId,
        itemId: it.itemId,
        archivedPath: '/tmp/arch.m4a',
      );

      await repo.clearToEmpty(personId: personId, itemId: it.itemId);

      final updated = await _byId(db, it.itemId);
      expect(updated.state, RitualRepo.stateEmpty);
      expect(updated.activePath, null);
      expect(updated.archivedPath, null);
      expect(updated.recordedAt, null);
      expect(updated.archivedAt, null);
    });

    test('rename works for empty, recorded, archived', () async {
      final it0 = await _slot(db, personId, sleeveId, 0);

      await repo.rename(personId: personId, itemId: it0.itemId, label: 'A');
      expect((await _byId(db, it0.itemId)).label, 'A');

      await repo.setRecorded(
        personId: personId,
        itemId: it0.itemId,
        label: '',
        activePath: '/tmp/a.m4a',
        sizeBytes: 1,
      );
      await repo.rename(personId: personId, itemId: it0.itemId, label: 'B');
      expect((await _byId(db, it0.itemId)).label, 'B');

      await repo.setArchived(
        personId: personId,
        itemId: it0.itemId,
        archivedPath: '/tmp/arch.m4a',
      );
      await repo.rename(personId: personId, itemId: it0.itemId, label: 'C');
      expect((await _byId(db, it0.itemId)).label, 'C');
    });

    test('markPlayed increments usageCountTotal and sets lastUsedAt (recorded)', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: '',
        activePath: '/tmp/a.m4a',
        sizeBytes: 1,
      );

      final before = await _byId(db, it.itemId);
      expect(before.usageCountTotal, 0);
      expect(before.lastUsedAt, null);

      await repo.markPlayed(personId: personId, itemId: it.itemId);

      final after = await _byId(db, it.itemId);
      expect(after.usageCountTotal, 1);
      expect(after.lastUsedAt, isNotNull);
    });

    test('markPlayed allowed on archived too', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: '',
        activePath: '/tmp/a.m4a',
        sizeBytes: 1,
      );
      await repo.setArchived(
        personId: personId,
        itemId: it.itemId,
        archivedPath: '/tmp/arch.m4a',
      );

      await repo.markPlayed(personId: personId, itemId: it.itemId);

      final after = await _byId(db, it.itemId);
      expect(after.usageCountTotal, 1);
      expect(after.lastUsedAt, isNotNull);
    });

    test('auto slot is not created when an empty already exists', () async {
      final before = await _itemsOfSleeve(db, personId, sleeveId);
      final lenBefore = before.length;
      expect(before.any((x) => x.state == RitualRepo.stateEmpty), true);

      final it0 = await _slot(db, personId, sleeveId, 0);
      await repo.setRecorded(
        personId: personId,
        itemId: it0.itemId,
        label: '',
        activePath: '/tmp/a.m4a',
        sizeBytes: 1,
      );

      final after = await _itemsOfSleeve(db, personId, sleeveId);
      expect(after.length, lenBefore);
      expect(after.any((x) => x.state == RitualRepo.stateEmpty), true);
    });

    test('auto slot created exactly once when last empty is consumed', () async {
      final items = await _itemsOfSleeve(db, personId, sleeveId);

      for (final it in items) {
        await repo.setRecorded(
          personId: personId,
          itemId: it.itemId,
          label: '',
          activePath: '/tmp/${it.slotIndex}.m4a',
          sizeBytes: 1,
        );
      }

      final after = await _itemsOfSleeve(db, personId, sleeveId);
      expect(after.length, 5);

      final empty = after.firstWhere((x) => x.state == RitualRepo.stateEmpty);
      await repo.setRecorded(
        personId: personId,
        itemId: empty.itemId,
        label: '',
        activePath: '/tmp/new.m4a',
        sizeBytes: 1,
      );

      final after2 = await _itemsOfSleeve(db, personId, sleeveId);
      expect(after2.length, 6);
      expect(after2.any((x) => x.state == RitualRepo.stateEmpty), true);
    });

    test('setRecorded logs a recorded event with correct personId and itemId', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: 'Test',
        activePath: '/tmp/a.m4a',
        sizeBytes: 123,
      );

      final events = await _eventsForItem(db, it.itemId);
      expect(events.isNotEmpty, true);

      final last = events.last;
      expect(last.personId, personId);
      expect(last.itemId, it.itemId);
      expect(last.eventType, RitualEventType.recorded.eventName);
      expect(last.sleeveId, sleeveId);
    });

    test('rename logs a renamed event with metadata label', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.rename(personId: personId, itemId: it.itemId, label: 'Hello');

      final events = await _eventsForItem(db, it.itemId);
      final renamed = events
          .where((e) => e.eventType == RitualEventType.renamed.eventName)
          .toList();
      expect(renamed.length, 1);

      final meta = renamed.single.metadata;
      expect(meta, isNotNull);

      final decoded = jsonDecode(meta!) as Map<String, dynamic>;
      expect(decoded['label'], 'Hello');
    });

    test('archive + restore log both events in order', () async {
      final it = await _slot(db, personId, sleeveId, 0);

      await repo.setRecorded(
        personId: personId,
        itemId: it.itemId,
        label: '',
        activePath: '/tmp/a.m4a',
        sizeBytes: 1,
      );
      await repo.setArchived(
        personId: personId,
        itemId: it.itemId,
        archivedPath: '/tmp/arch.m4a',
      );
      await repo.restore(
        personId: personId,
        itemId: it.itemId,
        activePath: '/tmp/a2.m4a',
      );

      final events = await _eventsForItem(db, it.itemId);
      final types = events.map((e) => e.eventType).toList();

      final idxArchived = types.indexOf(RitualEventType.archived.eventName);
      final idxRestored = types.indexOf(RitualEventType.restored.eventName);

      expect(idxArchived, greaterThan(-1));
      expect(idxRestored, greaterThan(-1));
      expect(idxRestored, greaterThan(idxArchived));
    });
  });
}

Future<List<RitualItem>> _itemsOfSleeve(
  AppDb db,
  String personId,
  String sleeveId,
) {
  return (db.select(db.ritualItems)
        ..where((t) =>
            t.personId.equals(personId) & t.sleeveId.equals(sleeveId))
        ..orderBy([(t) => drift.OrderingTerm(expression: t.slotIndex)]))
      .get();
}

Future<RitualItem> _slot(
  AppDb db,
  String personId,
  String sleeveId,
  int slotIndex,
) {
  return (db.select(db.ritualItems)
        ..where((t) =>
            t.personId.equals(personId) &
            t.sleeveId.equals(sleeveId) &
            t.slotIndex.equals(slotIndex)))
      .getSingle();
}

Future<RitualItem> _byId(AppDb db, String itemId) {
  return (db.select(db.ritualItems)..where((t) => t.itemId.equals(itemId)))
      .getSingle();
}

Future<List<RitualEvent>> _eventsForItem(AppDb db, String itemId) {
  return (db.select(db.ritualEvents)
        ..where((t) => t.itemId.equals(itemId))
        ..orderBy([(t) => drift.OrderingTerm(expression: t.timestamp)]))
      .get();
}