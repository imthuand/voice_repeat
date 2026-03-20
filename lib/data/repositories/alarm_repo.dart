import 'package:drift/drift.dart';

import '../../domain/constants.dart';
import '../db/app_db.dart';
import '../ids.dart';

class AlarmRepo {
  AlarmRepo(this.db);

  final AppDb db;

  int _now() => DateTime.now().millisecondsSinceEpoch;

  Future<RitualSchedule?> getScheduleForItem(String itemId) {
    return (db.select(db.ritualSchedules)
          ..where((t) => t.itemId.equals(itemId)))
        .getSingleOrNull();
  }

  Stream<RitualSchedule?> watchScheduleForItem(String itemId) {
    return (db.select(db.ritualSchedules)
          ..where((t) => t.itemId.equals(itemId)))
        .watchSingleOrNull();
  }

  Future<void> saveScheduleForItem({
    required String itemId,
    required String personId,
    required String label,
    required bool enabled,
    required int hour,
    required int minute,
    required int weekdayMask,
  }) async {
    if (hour < 0 || hour > 23) {
      throw StateError('Hour must be between 0 and 23');
    }
    if (minute < 0 || minute > 59) {
      throw StateError('Minute must be between 0 and 59');
    }
    if (weekdayMask == 0) {
      throw StateError('At least one weekday must be selected');
    }

    final existing = await getScheduleForItem(itemId);
    final now = _now();

    if (existing == null) {
      await db.into(db.ritualSchedules).insert(
            RitualSchedulesCompanion.insert(
              scheduleId: Ids.v4(),
              itemId: itemId,
              personId: personId,
              label: Value(label),
              enabled: Value(enabled),
              hour: hour,
              minute: minute,
              weekdayMask: weekdayMask,
              createdAt: now,
              updatedAt: now,
            ),
          );
      return;
    }

    await (db.update(db.ritualSchedules)
          ..where((t) => t.scheduleId.equals(existing.scheduleId)))
        .write(
      RitualSchedulesCompanion(
        label: Value(label),
        enabled: Value(enabled),
        hour: Value(hour),
        minute: Value(minute),
        weekdayMask: Value(weekdayMask),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> setEnabledForItem({
    required String itemId,
    required bool enabled,
  }) async {
    final existing = await getScheduleForItem(itemId);
    if (existing == null) return;

    await (db.update(db.ritualSchedules)
          ..where((t) => t.scheduleId.equals(existing.scheduleId)))
        .write(
      RitualSchedulesCompanion(
        enabled: Value(enabled),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> deleteScheduleForItem(String itemId) async {
    await (db.delete(db.ritualSchedules)..where((t) => t.itemId.equals(itemId)))
        .go();
  }

  String describeWeekdayMask(int mask) {
    final all = AlarmWeekday.ordered;
    final weekdays = all.where((d) => AlarmWeekday.contains(mask, d)).toList();

    if (weekdays.length == 7) {
      return 'Daily';
    }

    const workdays = <int>[
      AlarmWeekday.monday,
      AlarmWeekday.tuesday,
      AlarmWeekday.wednesday,
      AlarmWeekday.thursday,
      AlarmWeekday.friday,
    ];

    const weekend = <int>[
      AlarmWeekday.saturday,
      AlarmWeekday.sunday,
    ];

    final isWeekdays =
        weekdays.length == workdays.length &&
        weekdays.every(workdays.contains);

    if (isWeekdays) {
      return 'Weekdays';
    }

    final isWeekend =
        weekdays.length == weekend.length &&
        weekdays.every(weekend.contains);

    if (isWeekend) {
      return 'Weekend';
    }

    return weekdays
        .map((d) => AlarmWeekday.weekdayShortLabels[d] ?? '?')
        .join(' ');
  }

  String formatTime(int hour, int minute) {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String describeSchedule(RitualSchedule schedule) {
    return '${formatTime(schedule.hour, schedule.minute)} · ${describeWeekdayMask(schedule.weekdayMask)}';
  }
}