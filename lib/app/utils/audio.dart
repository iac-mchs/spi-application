
import 'package:audioplayers/audioplayers.dart';

class AudioController {
  late AudioCache _player;
  late AudioPlayer _instance;
  bool isPlaying = false;

  AudioController() : _player = new AudioCache(prefix: 'assets/audio/');

  play() async {
    if (isPlaying) return;
    _instance = await _player.loop('03265.mp3');
    isPlaying = true;
  }

  stop() {
    if (!isPlaying) return;
    _instance.stop();
    isPlaying = false;
  }
}