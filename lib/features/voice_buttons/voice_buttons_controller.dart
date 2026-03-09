import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/constants.dart';
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

  late final IntegrityService integrity = IntegrityService(
    db: repo.db,
    repo: repo,
    storage: storage,
  );

  String activeSleeveId = SleeveDefaults.defaultId;

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

  Future<void> initializeSleeveSelection() async {
    final saved = await repo.getLastActiveSleeveId(personId: personId);
    activeSleeveId = saved;
    notifyListeners();
  }

  Future<void> setActiveSleeve(String sleeveId) async {
    activeSleeveId = sleeveId;
    await repo.setLastActiveSleeveId(
      personId: personId,
      sleeveId: sleeveId,
    );
    notifyListeners();
  }

  Future<void> createSleeve(String name) async {
    try {
      final sleeveId = await repo.createSleeve(
        personId: personId,
        name: name,
      );
      activeSleeveId = sleeveId;
      await repo.setLastActiveSleeveId(
        personId: personId,
        sleeveId: sleeveId,
      );
      _emitUi('Sleeve created.');
    } catch (e) {
      _emitUi(e.toString().replaceFirst('Bad state: ', ''));
    }
  }

  Future<void> renameActiveSleeve(String name) async {
    try {
      await repo.renameSleeve(
        personId: personId,
        sleeveId: activeSleeveId,
        name: name,
      );
      _emitUi('Sleeve renamed.');
    } catch (e) {
      _emitUi(e.toString().replaceFirst('Bad state: ', ''));
    }
  }

  Future<void> deleteActiveSleeve() async {
    try {
      await repo.deleteSleeve(
        personId: personId,
        sleeveId: activeSleeveId,
      );
      activeSleeveId = SleeveDefaults.defaultId;
      await repo.setLastActiveSleeveId(
        personId: personId,
        sleeveId: SleeveDefaults.defaultId,
      );
      _emitUi('Sleeve deleted.');
      notifyListeners();
    } catch (e) {
      _emitUi(e.toString().replaceFirst('Bad state: ', ''));
    }
  }

  String _summaryText(
    String prefix,
    IntegritySummary summary,
  ) {
    final remaining = summary.issues - summary.fixed;
    return '$prefix Checked ${summary.checked}. Issues ${summary.issues}. Fixed ${summary.fixed}. Remaining ${remaining < 0 ? 0 : remaining}.';
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
        _recordingPathByItemId.remove(itemId) ??
        await storage.newActivePath(itemId);
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
    await repo.setArchived(
      personId: personId,
      itemId: itemId,
      archivedPath: to,
    );
  }

  Future<void> restore(String itemId, String archivedPath) async {
    final exists = await storage.fileExists(archivedPath);
    if (!exists) {
      _emitUi('Cannot restore. Audio file is missing.');
      return;
    }

    final to = await storage.newActivePath(itemId);
    await storage.move(archivedPath, to);
    await repo.restore(
      personId: personId,
      itemId: itemId,
      activePath: to,
    );
  }

  Future<void> deleteActive(String itemId, {String? activePath}) async {
    await _stopPlayingIfAny();

    if (activePath != null) {
      await storage.deleteIfExists(activePath);
    }

    await repo.deleteSlot(personId: personId, itemId: itemId);
    _emitUi('Slot deleted permanently.');
  }

  Future<void> deleteArchived(String itemId, {String? archivedPath}) async {
    await _stopPlayingIfAny();

    if (archivedPath != null) {
      await storage.deleteIfExists(archivedPath);
    }

    await repo.deleteSlot(personId: personId, itemId: itemId);
    _emitUi('Slot deleted permanently.');
  }

  Future<void> clearSlotKeepButton(String itemId) async {
    await _stopPlayingIfAny();
    await repo.clearToEmpty(personId: personId, itemId: itemId);
    _emitUi('Slot cleared.');
  }

  Future<void> repairRecordedIssueToEmpty(String itemId) async {
    await _stopPlayingIfAny();
    await repo.repairMissingRecordedToEmpty(
      personId: personId,
      itemId: itemId,
    );
    _emitUi('Broken active item repaired to empty.');
  }

  Future<void> repairArchivedIssueToEmpty(String itemId) async {
    await _stopPlayingIfAny();
    await repo.repairMissingArchivedToEmpty(
      personId: personId,
      itemId: itemId,
    );
    _emitUi('Broken archived item repaired to empty.');
  }

  Future<IntegritySummary> runIntegrityCheck() async {
    final summary = await integrity.checkPerson(personId: personId);
    _emitUi(_summaryText('Integrity check done.', summary));
    return summary;
  }

  Future<IntegritySummary> runIntegrityCheckRepairRecorded() async {
    final summary = await integrity.checkPerson(
      personId: personId,
      repairMissingRecordedToEmpty: true,
    );
    _emitUi(_summaryText('Integrity repair for active items done.', summary));
    return summary;
  }

  Future<IntegritySummary> runIntegrityCheckRepairAll() async {
    final summary = await integrity.checkPerson(
      personId: personId,
      repairMissingRecordedToEmpty: true,
      repairMissingArchivedToEmpty: true,
    );
    _emitUi(_summaryText('Integrity repair for all items done.', summary));
    return summary;
  }

  @override
  void dispose() {
    audio.dispose();
    super.dispose();
  }
}