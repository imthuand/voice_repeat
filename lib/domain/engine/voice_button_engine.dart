import '../models/voice_button.dart';

enum VoiceEventType {
  startRecording,
  stopRecordingSuccess,
  stopRecordingFailed,
  startPlaying,
  stopPlaying,
  delete,
  archive,
}

class VoiceEvent {
  final int id;
  final VoiceEventType type;
  final String? filePath;

  const VoiceEvent({
    required this.id,
    required this.type,
    this.filePath,
  });
}

class VoiceButtonEngine {
  final List<VoiceButton> _buttons;

  VoiceButtonEngine({int initialButtons = 4})
      : _buttons = List.generate(
          initialButtons,
          (i) => VoiceButton(id: i, filePath: null, status: VoiceStatus.empty),
        );

  List<VoiceButton> get buttons => List.unmodifiable(_buttons);

  void apply(VoiceEvent e) {
    final i = _buttons.indexWhere((b) => b.id == e.id);
    if (i < 0) return;

    final current = _buttons[i];

    switch (e.type) {
      case VoiceEventType.startRecording:
        _buttons[i] = current.copyWith(status: VoiceStatus.recording);
        break;

      case VoiceEventType.stopRecordingSuccess:
        _buttons[i] = VoiceButton(
          id: current.id,
          filePath: e.filePath,
          status: VoiceStatus.recorded,
        );
        _ensureAtLeastOneEmpty();
        break;

      case VoiceEventType.stopRecordingFailed:
        _buttons[i] = VoiceButton(id: current.id, filePath: null, status: VoiceStatus.empty);
        _ensureAtLeastOneEmpty();
        break;

      case VoiceEventType.startPlaying:
        _buttons[i] = current.copyWith(status: VoiceStatus.playing);
        break;

      case VoiceEventType.stopPlaying:
        if (current.filePath != null) {
          _buttons[i] = current.copyWith(status: VoiceStatus.recorded);
        } else {
          _buttons[i] = current.copyWith(status: VoiceStatus.empty);
        }
        break;

      case VoiceEventType.delete:
      case VoiceEventType.archive:
        _buttons[i] = VoiceButton(id: current.id, filePath: null, status: VoiceStatus.empty);
        _ensureAtLeastOneEmpty();
        break;
    }
  }

  void _ensureAtLeastOneEmpty() {
    final hasEmpty = _buttons.any((b) => b.status == VoiceStatus.empty);
    if (hasEmpty) return;

    final nextId = _buttons.isEmpty ? 0 : (_buttons.last.id + 1);
    _buttons.add(VoiceButton(id: nextId, filePath: null, status: VoiceStatus.empty));
  }
}