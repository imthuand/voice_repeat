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