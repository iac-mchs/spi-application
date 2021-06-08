import 'package:just_audio/just_audio.dart';

class AudioController {
  late AudioPlayer _player;

  AudioController() : _player = new AudioPlayer() {
    _player.setAsset('assets/audio/03265.mp3');
    _player.setLoopMode(LoopMode.all);
  }

  PlayerState get currentState => _player.playerState;

  play() {
    if (this.currentState.playing) return;
    _player.play();
  }

  stop() {
    if (this.currentState.playing == false) return;
    _player.stop();
  }
}