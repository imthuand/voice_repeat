import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_db.g.dart';

class Persons extends Table {
  TextColumn get personId => text()();
  TextColumn get displayName => text()();
  TextColumn get role => text()();
  TextColumn get language => text().withDefault(const Constant('de'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {personId};
}

@TableIndex(name: 'idx_ritual_items_person_state', columns: {#personId, #state})
@TableIndex(name: 'idx_ritual_items_person_archived_at', columns: {#personId, #archivedAt})
@TableIndex(name: 'idx_ritual_items_person_sleeve_state', columns: {#personId, #sleeveId, #state})
class RitualItems extends Table {
  TextColumn get itemId => text()();

  TextColumn get personId => text()();
  IntColumn get slotIndex => integer()();

  TextColumn get label => text().withDefault(const Constant(''))();

  // empty, recorded, archived
  TextColumn get state => text().withDefault(const Constant('empty'))();

  // Denormalized paths
  TextColumn get activePath => text().nullable()();
  TextColumn get archivedPath => text().nullable()();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();

  IntColumn get usageCountTotal => integer().withDefault(const Constant(0))();
  IntColumn get lastUsedAt => integer().nullable()();

  // Phase 1 hardening, sleeve and indexing ready
  TextColumn get sleeveId => text().withDefault(const Constant('default'))();
  TextColumn get searchText => text().withDefault(const Constant(''))();
  IntColumn get recordedAt => integer().nullable()();
  IntColumn get archivedAt => integer().nullable()();

  // v1.1 hardening: integrity layer
  TextColumn get integrityStatus => text().withDefault(const Constant('ok'))();
  IntColumn get integrityCheckedAt => integer().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {itemId};

  @override
  List<Set<Column>> get uniqueKeys => [
        {personId, slotIndex},
      ];
}

@TableIndex(name: 'idx_ritual_events_person_time', columns: {#personId, #timestamp})
@TableIndex(name: 'idx_ritual_events_item_time', columns: {#itemId, #timestamp})
@TableIndex(name: 'idx_ritual_events_person_sleeve_time', columns: {#personId, #sleeveId, #timestamp})
class RitualEvents extends Table {
  TextColumn get eventId => text()();
  TextColumn get itemId => text()();
  TextColumn get personId => text()();
  TextColumn get eventType => text()();
  IntColumn get timestamp => integer()();
  TextColumn get metadata => text().nullable()();

  // Phase 1 enrichment foundation
  TextColumn get sleeveId => text().withDefault(const Constant('default'))();
  IntColumn get slotIndex => integer().nullable()();
  TextColumn get itemState => text().withDefault(const Constant(''))();
  TextColumn get path => text().withDefault(const Constant(''))();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  TextColumn get source => text().withDefault(const Constant('repo'))();
  TextColumn get enforcementMode => text().withDefault(const Constant('soft'))();

  @override
  Set<Column> get primaryKey => {eventId};
}

@DriftDatabase(tables: [Persons, RitualItems, RitualEvents])
class AppDb extends _$AppDb {
  AppDb({QueryExecutor? executor}) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Add RitualItems columns
            await m.addColumn(ritualItems, ritualItems.sleeveId);
            await m.addColumn(ritualItems, ritualItems.searchText);
            await m.addColumn(ritualItems, ritualItems.recordedAt);
            await m.addColumn(ritualItems, ritualItems.archivedAt);

            // Add RitualEvents columns
            await m.addColumn(ritualEvents, ritualEvents.sleeveId);
            await m.addColumn(ritualEvents, ritualEvents.slotIndex);
            await m.addColumn(ritualEvents, ritualEvents.itemState);
            await m.addColumn(ritualEvents, ritualEvents.path);
            await m.addColumn(ritualEvents, ritualEvents.sizeBytes);
            await m.addColumn(ritualEvents, ritualEvents.source);
            await m.addColumn(ritualEvents, ritualEvents.enforcementMode);

            // Create indexes for existing installs
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_ritual_items_person_state ON ritual_items(person_id, state)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_ritual_items_person_archived_at ON ritual_items(person_id, archived_at)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_ritual_items_person_sleeve_state ON ritual_items(person_id, sleeve_id, state)',
            );

            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_ritual_events_person_time ON ritual_events(person_id, timestamp)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_ritual_events_item_time ON ritual_events(item_id, timestamp)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_ritual_events_person_sleeve_time ON ritual_events(person_id, sleeve_id, timestamp)',
            );

            // Backfill
            await customStatement(
              "UPDATE ritual_items SET search_text = COALESCE(label, '') WHERE search_text = ''",
            );
            await customStatement(
              "UPDATE ritual_items SET archived_at = updated_at WHERE state = 'archived' AND archived_at IS NULL",
            );
            await customStatement(
              "UPDATE ritual_items SET recorded_at = updated_at WHERE state = 'recorded' AND recorded_at IS NULL",
            );
          }

          if (from < 3) {
            await m.addColumn(ritualItems, ritualItems.integrityStatus);
            await m.addColumn(ritualItems, ritualItems.integrityCheckedAt);

            // Backfill for existing rows
            await customStatement(
              "UPDATE ritual_items SET integrity_status = 'ok' WHERE integrity_status IS NULL",
            );
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final support = await getApplicationSupportDirectory();
    final baseDir = Directory(p.join(support.path, 'voice_repeat'));
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }

    final target = File(p.join(baseDir.path, 'voice_repeat.sqlite'));

    // Best effort migrate from documents if present and support DB not created yet
    try {
      if (!await target.exists()) {
        final docs = await getApplicationDocumentsDirectory();
        final legacy = File(p.join(docs.path, 'voice_repeat.sqlite'));
        if (await legacy.exists()) {
          await legacy.copy(target.path);
          try {
            await legacy.delete();
          } catch (_) {}
        }
      }
    } catch (_) {}

    return NativeDatabase.createInBackground(target);
  });
}