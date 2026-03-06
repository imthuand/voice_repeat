class ItemState {
  static const empty = 'empty';
  static const recorded = 'recorded';
  static const archived = 'archived';
}

class IntegrityStatus {
  static const ok = 'ok';
  static const missingPath = 'missing_path';
  static const missingFile = 'missing_file';
}

class EventSource {
  static const repo = 'repo';
  static const integrity = 'integrity';
}

class EnforcementMode {
  static const soft = 'soft';
  static const strict = 'strict';
}