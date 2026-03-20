import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/constants.dart';

part 'app_db.g.dart';

class Persons extends Table {
  TextColumn get personId => text()();
  TextColumn get displayName => text()();
  TextColumn get role => text()();
  TextColumn get language => text().withDefault(const Constant('de'))();
  TextColumn get lastActiveSleeveId => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {personId};
}

@TableIndex(name: 'idx_sleeves_person_sort', columns: {#personId, #sortOrder})
class Sleeves extends Table {
  TextColumn get sleeveId => text()();
  TextColumn get personId => text()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {sleeveId};

  @override
  List<Set<Column>> get uniqueKeys => [
        {personId, name},
      ];
}

@TableIndex(name: 'idx_ritual_items_person_state', columns: {#personId, #state})
@TableIndex(
  name: 'idx_ritual_items_person_archived_at',
  columns: {#personId, #archivedAt},
)
@TableIndex(
  name: 'idx_ritual_items_person_sleeve_state',
  columns: {#personId, #sleeveId, #state},
)
class RitualItems extends Table {
  TextColumn get itemId => text()();
  TextColumn get personId => text()();
  IntColumn get slotIndex => integer()();
  TextColumn get label => text().withDefault(const Constant(''))();
  TextColumn get state =>
      text().withDefault(const Constant(ItemState.empty))();
  TextColumn get activePath => text().nullable()();
  TextColumn get archivedPath => text().nullable()();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  IntColumn get usageCountTotal => integer().withDefault(const Constant(0))();
  IntColumn get lastUsedAt => integer().nullable()();
  TextColumn get sleeveId =>
      text().withDefault(const Constant(SleeveDefaults.defaultId))();
  TextColumn get searchText => text().withDefault(const Constant(''))();
  IntColumn get recordedAt => integer().nullable()();
  IntColumn get archivedAt => integer().nullable()();
  TextColumn get integrityStatus =>
      text().withDefault(const Constant(IntegrityStatus.ok))();
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

@TableIndex(
  name: 'idx_ritual_events_person_time',
  columns: {#personId, #timestamp},
)
@TableIndex(name: 'idx_ritual_events_item_time', columns: {#itemId, #timestamp})
@TableIndex(
  name: 'idx_ritual_events_person_sleeve_time',
  columns: {#personId, #sleeveId, #timestamp},
)
class RitualEvents extends Table {
  TextColumn get eventId => text()();
  TextColumn get itemId => text()();
  TextColumn get personId => text()();
  TextColumn get eventType => text()();
  IntColumn get timestamp => integer()();
  TextColumn get metadata => text().nullable()();
  TextColumn get sleeveId =>
      text().withDefault(const Constant(SleeveDefaults.defaultId))();
  IntColumn get slotIndex => integer().nullable()();
  TextColumn get itemState => text().withDefault(const Constant(''))();
  TextColumn get path => text().withDefault(const Constant(''))();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  TextColumn get source => text().withDefault(const Constant(EventSource.repo))();
  TextColumn get enforcementMode =>
      text().withDefault(const Constant(EnforcementMode.soft))();

  @override
  Set<Column> get primaryKey => {eventId};
}

@TableIndex(
  name: 'idx_ritual_schedules_person_enabled_time',
  columns: {#personId, #enabled, #hour, #minute},
)
@TableIndex(
  name: 'idx_ritual_schedules_item',
  columns: {#itemId},
)
class RitualSchedules extends Table {
  TextColumn get scheduleId => text()();
  TextColumn get itemId => text()();
  TextColumn get personId => text()();
  TextColumn get kind =>
      text().withDefault(const Constant(AlarmScheduleKind.weeklyMask))();
  TextColumn get label => text().withDefault(const Constant(''))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  IntColumn get weekdayMask => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get lastTriggeredAt => integer().nullable()();
  IntColumn get nextTriggerAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {scheduleId};

  @override
  List<Set<Column>> get uniqueKeys => [
        {itemId},
      ];
}

@DriftDatabase(
  tables: [
    Persons,
    Sleeves,
    RitualItems,
    RitualEvents,
    RitualSchedules,
  ],
)
class AppDb extends _$AppDb {
  AppDb({QueryExecutor? executor}) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(ritualItems, ritualItems.sleeveId);
            await m.addColumn(ritualItems, ritualItems.searchText);
            await m.addColumn(ritualItems, ritualItems.recordedAt);
            await m.addColumn(ritualItems, ritualItems.archivedAt);
            await m.addColumn(ritualEvents, ritualEvents.sleeveId);
            await m.addColumn(ritualEvents, ritualEvents.slotIndex);
            await m.addColumn(ritualEvents, ritualEvents.itemState);
            await m.addColumn(ritualEvents, ritualEvents.path);
            await m.addColumn(ritualEvents, ritualEvents.sizeBytes);
            await m.addColumn(ritualEvents, ritualEvents.source);
            await m.addColumn(ritualEvents, ritualEvents.enforcementMode);

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
            await customStatement(
              "UPDATE ritual_items SET integrity_status = 'ok' WHERE integrity_status IS NULL",
            );
          }

          if (from < 4) {
            await m.createTable(sleeves);
            await customStatement('''
              INSERT OR IGNORE INTO sleeves (sleeve_id, person_id, name, sort_order, created_at, updated_at)
              SELECT '${SleeveDefaults.defaultId}', person_id, '${SleeveDefaults.defaultName}', 0, updated_at, updated_at
              FROM persons
            ''');
            await customStatement('''
              UPDATE ritual_items
              SET sleeve_id = '${SleeveDefaults.defaultId}'
              WHERE sleeve_id IS NULL OR sleeve_id = ''
            ''');
          }

          if (from < 5) {
            await m.addColumn(persons, persons.lastActiveSleeveId);
            await customStatement('''
              UPDATE persons
              SET last_active_sleeve_id = '${SleeveDefaults.defaultId}'
              WHERE last_active_sleeve_id IS NULL OR last_active_sleeve_id = ''
            ''');
          }

          if (from < 6) {
            await m.createTable(ritualSchedules);
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