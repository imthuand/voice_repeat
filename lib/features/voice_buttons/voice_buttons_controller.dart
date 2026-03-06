import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../data/repositories/ritual_repo.dart';
import '../../data/services/integrity_service.dart';
import '../../infrastructure/audio_service.dart';
import '../../infrastructure/file_storage.dart';

class UiMessage {
  final int id;
  final String text;
  const UiMessage(this.id, this.text);
}

class VoiceButtonsController extends ChangeNotifier {
  VoiceButtonsController({
    required this.repo,
    required this.audio,
    required this.storage,
    required this.personId,
  });

  final RitualRepo repo;
  final AudioService audio;
  final FileStorage storage;
  final String personId;

  late final IntegrityService integrity =
      IntegrityService(db: repo.db, repo: repo, storage: storage);

  String? recordingItemId;
  String? playingItemId;

  UiMessage? uiMessage;
  int _uiMessageSeq = 0;

  final Map<String, String> _recordingPathByItemId = {};

  void _emitUi(String text) {
    _uiMessageSeq++;
    uiMessage = UiMessage(_uiMessageSeq, text);
    notifyListeners();
  }

  Future<void> _stopPlayingIfAny() async {
    if (playingItemId == null) return;
    try {
      await audio.stopPlay();
    } catch (_) {}
    playingItemId = null;
    notifyListeners();
  }

  Future<int> _waitForStableFileSize(String path) async {
    var size = await storage.fileSize(path);
    if (size > 0) return size;

    for (var i = 0; i < 8; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      size = await storage.fileSize(path);
      if (size > 0) return size;
    }
    return size;
  }

  Future<void> startHold(String itemId) async {
    if (recordingItemId != null) return;

    await _stopPlayingIfAny();

    final ok = await audio.hasMicPermission();
    if (!ok) {
      _emitUi('Microphone permission is required.');
      return;
    }

    final path = await storage.newActivePath(itemId);
    _recordingPathByItemId[itemId] = path;

    recordingItemId = itemId;
    notifyListeners();

    try {
      await audio.startRecording(path);
    } catch (_) {
      recordingItemId = null;
      _recordingPathByItemId.remove(itemId);
      _emitUi('Recording failed to start.');
    }
  }

  Future<void> stopHold(String itemId) async {
    if (recordingItemId != itemId) return;

    String? stoppedPath;
    try {
      stoppedPath = await audio.stopRecording();
    } catch (_) {}

    final fallbackPath =
        _recordingPathByItemId.remove(itemId) ?? await storage.newActivePath(itemId);
    final path = stoppedPath ?? fallbackPath;

    recordingItemId = null;
    notifyListeners();

    final size = await _waitForStableFileSize(path);

    if (size <= 0) {
      await storage.deleteIfExists(path);
      _emitUi('Recording was empty and was discarded.');
      return;
    }

    await repo.setRecorded(
      personId: personId,
      itemId: itemId,
      label: '',
      activePath: path,
      sizeBytes: size,
    );
  }

  Future<bool> togglePlay(String itemId, String path) async {
    if (playingItemId == itemId) {
      try {
        await audio.stopPlay();
      } catch (_) {}
      playingItemId = null;
      notifyListeners();
      return false;
    }

    await _stopPlayingIfAny();

    final exists = await storage.fileExists(path);
    if (!exists) {
      playingItemId = null;
      _emitUi('Audio file is missing.');
      return false;
    }

    playingItemId = itemId;
    notifyListeners();

    try {
      await audio.playFile(path);
      return true;
    } catch (_) {
      _emitUi('Playback failed.');
      return false;
    } finally {
      playingItemId = null;
      notifyListeners();
    }
  }

  Future<void> archive(String itemId, String activePath) async {
    final exists = await storage.fileExists(activePath);
    if (!exists) {
      _emitUi('Cannot archive. Audio file is missing.');
      return;
    }
    final to = await storage.archivePath(itemId);
    await storage.move(activePath, to);
    await repo.setArchived(personId: personId, itemId: itemId, archivedPath: to);
  }

  Future<void> restore(String itemId, String archivedPath) async {
    final exists = await storage.fileExists(archivedPath);
    if (!exists) {
      _emitUi('Cannot restore. Audio file is missing.');
      return;
    }
    final to = await storage.newActivePath(itemId);
    await storage.move(archivedPath, to);
    await repo.restore(personId: personId, itemId: itemId, activePath: to);
  }

  /// Delete removes the slot row so the button disappears
  Future<void> deleteActive(String itemId, {String? activePath}) async {
    await _stopPlayingIfAny();

    if (activePath != null) {
      await storage.deleteIfExists(activePath);
    }
    await repo.deleteSlot(personId: personId, itemId: itemId);
    _emitUi('Slot deleted.');
  }

  /// Delete removes the slot row so the button disappears
  Future<void> deleteArchived(String itemId, {String? archivedPath}) async {
    await _stopPlayingIfAny();

    if (archivedPath != null) {
      await storage.deleteIfExists(archivedPath);
    }
    await repo.deleteSlot(personId: personId, itemId: itemId);
    _emitUi('Slot deleted.');
  }

  /// Optional helper if you still want a "clear but keep the slot" UX somewhere
  Future<void> clearSlotKeepButton(String itemId) async {
    await _stopPlayingIfAny();
    await repo.clearToEmpty(personId: personId, itemId: itemId);
    _emitUi('Slot cleared.');
  }

  Future<IntegritySummary> runIntegrityCheck() async {
    final summary = await integrity.checkPerson(personId: personId);
    _emitUi(
      'Integrity check done. Checked ${summary.checked}. Issues ${summary.issues}. Fixed ${summary.fixed}.',
    );
    return summary;
  }

  @override
  void dispose() {
    audio.dispose();
    super.dispose();
  }
}