import 'package:audioplayers/audioplayers.dart';

class SoundService {
  // Singleton pattern for easy global access
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// Play click sound
  Future<void> playClick() async {
    try {
      // Use BytesSource or AssetSource based on package version
      // AssetSource automatically targets the 'assets/' folder
      await _player.stop(); // Stops previous playback if clicked rapidly
      await _player.play(AssetSource('sounds/click.wav'));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void dispose() {
    _player.dispose();
  }
}