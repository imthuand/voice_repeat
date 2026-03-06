import 'dart:convert';

import 'package:drift/drift.dart';
import '../db/app_db.dart';
import '../ids.dart';
import '../repositories/ritual_repo.dart';
import '../../infrastructure/file_storage.dart';

class IntegrityStatus {
  static const String ok = 'ok';
  static const String missingPath = 'missing_path';
  static const String missingFile = 'missing_file';
}

/// Summary used by controller UI message
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

  /// Reconciliation light:
  /// - checks paths referenced by DB against filesystem
  /// - writes integrityStatus + integrityCheckedAt
  /// - logs summary and issue events into RitualEvents (as plain eventType strings)
  Future<IntegritySummary> checkPerson({required String personId}) async {
    final now = _now();

    final items = await (db.select(db.ritualItems)
          ..where((t) => t.personId.equals(personId)))
        .get();

    var checked = 0;
    var issues = 0;
    var fixed = 0;

    await db.transaction(() async {
      for (final it in items) {
        checked++;

        final expectedPath = _expectedPath(it);
        final status = await _computeStatus(it.state, expectedPath);

        if (status != IntegrityStatus.ok) {
          issues++;
        }

        // Update DB only if needed
        final needsUpdate =
            (it.integrityStatus != status) || (it.integrityCheckedAt == null);

        if (needsUpdate) {
          await (db.update(db.ritualItems)..where((t) => t.itemId.equals(it.itemId))).write(
            RitualItemsCompanion(
              integrityStatus: Value(status),
              integrityCheckedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
        } else {
          // still update checkedAt for recency if you want, but keeping it minimal here
          await (db.update(db.ritualItems)..where((t) => t.itemId.equals(it.itemId))).write(
            RitualItemsCompanion(
              integrityCheckedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
        }

        if (status != IntegrityStatus.ok) {
          await _logIntegrityEvent(
            personId: personId,
            item: it,
            eventType: 'integrityIssueDetected',
            metadata: {
              'status': status,
              'state': it.state,
              'path': expectedPath ?? '',
            },
          );
        }
      }

      await _logSummaryEvent(
        personId: personId,
        now: now,
        checked: checked,
        issues: issues,
        fixed: fixed,
      );
    });

    return IntegritySummary(checked: checked, issues: issues, fixed: fixed);
  }

  String? _expectedPath(RitualItem it) {
    if (it.state == RitualRepo.stateRecorded) return it.activePath;
    if (it.state == RitualRepo.stateArchived) return it.archivedPath;
    return null;
  }

  Future<String> _computeStatus(String state, String? path) async {
    if (state == RitualRepo.stateEmpty) return IntegrityStatus.ok;

    if (path == null || path.isEmpty) return IntegrityStatus.missingPath;

    final exists = await storage.fileExists(path);
    if (!exists) return IntegrityStatus.missingFile;

    return IntegrityStatus.ok;
  }

  Future<void> _logSummaryEvent({
    required String personId,
    required int now,
    required int checked,
    required int issues,
    required int fixed,
  }) async {
    await db.into(db.ritualEvents).insert(
          RitualEventsCompanion.insert(
            eventId: Ids.v4(),
            itemId: 'system',
            personId: personId,
            eventType: 'integrityChecked',
            timestamp: now,
            metadata: Value(jsonEncode({
              'checked': checked,
              'issues': issues,
              'fixed': fixed,
              'v': 1,
            })),
          ),
        );
  }

  Future<void> _logIntegrityEvent({
    required String personId,
    required RitualItem item,
    required String eventType,
    Map<String, dynamic>? metadata,
  }) async {
    final now = _now();

    final path = (item.state == RitualRepo.stateArchived) ? (item.archivedPath ?? '') : (item.activePath ?? '');

    await db.into(db.ritualEvents).insert(
          RitualEventsCompanion(
            eventId: Value(Ids.v4()),
            itemId: Value(item.itemId),
            personId: Value(personId),
            eventType: Value(eventType),
            timestamp: Value(now),
            metadata: metadata == null ? const Value(null) : Value(jsonEncode(metadata)),
            sleeveId: Value(item.sleeveId),
            slotIndex: Value(item.slotIndex),
            itemState: Value(item.state),
            path: Value(path),
            sizeBytes: Value(item.sizeBytes),
            source: const Value('integrity'),
            enforcementMode: const Value('soft'),
          ),
        );
  }
}