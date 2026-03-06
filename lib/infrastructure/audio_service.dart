import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasMicPermission() => _recorder.hasPermission();

  Future<void> startRecording(String path) async {
    await _recorder.start(
      const RecordConfig(),
      path: path,
    );
  }

  Future<String?> stopRecording() async {
    return _recorder.stop();
  }

  Future<void> playFile(String path) async {
    await _player.setFilePath(path);
    await _player.play();
  }

  Future<void> stopPlay() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _recorder.dispose();
  }
}