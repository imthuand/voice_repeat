class ItemState {
  static const empty = 'empty';
  static const recorded = 'recorded';
  static const archived = 'archived';
}

class IntegrityStatus {
  static const ok = 'ok';
  static const missingPath = 'missing_path';
  static const missingFile = 'missing_file';
  static const pathMismatch = 'path_mismatch';
}

class EventSource {
  static const repo = 'repo';
  static const integrity = 'integrity';
}

class ReservedItemId {
  static const system = 'system';
}

class SleeveDefaults {
  static const defaultId = 'default';
  static const defaultName = 'Default';
}

class EnforcementMode {
  static const soft = 'soft';
  static const strict = 'strict';
}

class RitualEventName {
  static const recorded = 'recorded';
  static const played = 'played';
  static const archived = 'archived';
  static const restored = 'restored';
  static const deleted = 'deleted';
  static const renamed = 'renamed';
  static const integrityChecked = 'integrityChecked';
  static const integrityIssueDetected = 'integrityIssueDetected';
  static const integrityAutoFixed = 'integrityAutoFixed';
}

class AlarmScheduleKind {
  static const weeklyMask = 'weekly_mask';
}

class AlarmWeekday {
  static const monday = 1;
  static const tuesday = 2;
  static const wednesday = 3;
  static const thursday = 4;
  static const friday = 5;
  static const saturday = 6;
  static const sunday = 7;

  static const ordered = <int>[
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  ];

  static int bitFor(int weekday) => 1 << (weekday - 1);

  static int maskOf(Iterable<int> weekdays) {
    var mask = 0;
    for (final weekday in weekdays) {
      mask |= bitFor(weekday);
    }
    return mask;
  }

  static bool contains(int mask, int weekday) {
    return (mask & bitFor(weekday)) != 0;
  }

  static const weekdayShortLabels = <int, String>{
    monday: 'Mon',
    tuesday: 'Tue',
    wednesday: 'Wed',
    thursday: 'Thu',
    friday: 'Fri',
    saturday: 'Sat',
    sunday: 'Sun',
  };

  static const weekdayTinyLabels = <int, String>{
    monday: 'M',
    tuesday: 'T',
    wednesday: 'W',
    thursday: 'T',
    friday: 'F',
    saturday: 'S',
    sunday: 'S',
  };
}