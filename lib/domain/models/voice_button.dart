enum VoiceStatus {
  empty,
  recording,
  recorded,
  playing,
}

class VoiceButton {
  final int id;
  final String? filePath;
  final VoiceStatus status;

  const VoiceButton({
    required this.id,
    required this.filePath,
    required this.status,
  });

  bool get hasRecording => filePath != null && status != VoiceStatus.empty;

  VoiceButton copyWith({
    String? filePath,
    VoiceStatus? status,
  }) {
    return VoiceButton(
      id: id,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
    );
  }
}