import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/constants.dart';
import '../../infrastructure/file_storage.dart';
import '../db/app_db.dart';
import '../ids.dart';
import '../repositories/ritual_repo.dart';

class IntegritySummary {
  final int checked;
  final int issues;
  final int fixed;

  const IntegritySummary({
    required this.checked,
    required this.issues,
    required this.fixed,
  });
}

class IntegrityService {
  IntegrityService({
    required this.db,
    required this.repo,
    required this.storage,
  });

  final AppDb db;
  final RitualRepo repo;
  final FileStorage storage;

  int _now() => DateTime.now().millisecondsSinceEpoch;

  Future<IntegritySummary> checkPerson({
    required String personId,
  }) async {
    final now = _now();

    final items = await (db.select(db.ritualItems)
          ..where((t) => t.personId.equals(personId)))
        .get();

    var checked = 0;
    var issues = 0;
    var fixed = 0;

    await db.transaction(() async {
      for (final item in items) {
        checked++;

        final result = await _computeIntegrity(item);

        await (db.update(db.ritualItems)..where((t) => t.itemId.equals(item.itemId))).write(
          RitualItemsCompanion(
            integrityStatus: Value(result.status),
            integrityCheckedAt: Value(now),
            updatedAt: Value(now),
          ),
        );

        if (result.status != IntegrityStatus.ok) {
          issues++;

          await _logIntegrityEvent(
            personId: personId,
            item: item,
            status: result.status,
            expectedPath: result.expectedPath,
          );
        }
      }

      await _logSummaryEvent(
        personId: personId,
        checked: checked,
        issues: issues,
        fixed: fixed,
        now: now,
      );
    });

    return IntegritySummary(
      checked: checked,
      issues: issues,
      fixed: fixed,
    );
  }

  Future<_IntegrityResult> _computeIntegrity(RitualItem item) async {
    if (item.state == ItemState.empty) {
      return const _IntegrityResult(
        status: IntegrityStatus.ok,
        expectedPath: '',
      );
    }

    if (item.state == ItemState.recorded) {
      if (item.activePath == null || item.activePath!.isEmpty) {
        return const _IntegrityResult(
          status: IntegrityStatus.missingPath,
          expectedPath: '',
        );
      }

      final exists = await storage.fileExists(item.activePath!);
      return _IntegrityResult(
        status: exists ? IntegrityStatus.ok : IntegrityStatus.missingFile,
        expectedPath: item.activePath!,
      );
    }

    if (item.state == ItemState.archived) {
      if (item.archivedPath == null || item.archivedPath!.isEmpty) {
        return const _IntegrityResult(
          status: IntegrityStatus.missingPath,
          expectedPath: '',
        );
      }

      final exists = await storage.fileExists(item.archivedPath!);
      return _IntegrityResult(
        status: exists ? IntegrityStatus.ok : IntegrityStatus.missingFile,
        expectedPath: item.archivedPath!,
      );
    }

    return const _IntegrityResult(
      status: IntegrityStatus.pathMismatch,
      expectedPath: '',
    );
  }

  Future<void> _logSummaryEvent({
    required String personId,
    required int checked,
    required int issues,
    required int fixed,
    required int now,
  }) async {
    await db.into(db.ritualEvents).insert(
          RitualEventsCompanion(
            eventId: Value(Ids.v4()),
            itemId: const Value(ReservedItemId.system),
            personId: Value(personId),
            eventType: const Value(RitualEventName.integrityChecked),
            timestamp: Value(now),
            metadata: Value(jsonEncode({
              'checked': checked,
              'issues': issues,
              'fixed': fixed,
              'v': 1,
            })),
            sleeveId: const Value('default'),
            slotIndex: const Value(-1),
            itemState: const Value(''),
            path: const Value(''),
            sizeBytes: const Value(0),
            source: const Value(EventSource.integrity),
            enforcementMode: const Value(EnforcementMode.soft),
          ),
        );
  }

  Future<void> _logIntegrityEvent({
    required String personId,
    required RitualItem item,
    required String status,
    required String expectedPath,
  }) async {
    final now = _now();

    await db.into(db.ritualEvents).insert(
          RitualEventsCompanion(
            eventId: Value(Ids.v4()),
            itemId: Value(item.itemId),
            personId: Value(personId),
            eventType: const Value(RitualEventName.integrityIssueDetected),
            timestamp: Value(now),
            metadata: Value(jsonEncode({
              'status': status,
              'state': item.state,
              'expectedPath': expectedPath,
              'v': 1,
            })),
            sleeveId: Value(item.sleeveId),
            slotIndex: Value(item.slotIndex),
            itemState: Value(item.state),
            path: Value(expectedPath),
            sizeBytes: Value(item.sizeBytes),
            source: const Value(EventSource.integrity),
            enforcementMode: const Value(EnforcementMode.soft),
          ),
        );
  }
}

class _IntegrityResult {
  final String status;
  final String expectedPath;

  const _IntegrityResult({
    required this.status,
    required this.expectedPath,
  });
}