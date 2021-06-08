
import 'dart:io';

import 'package:flutter_audio_desktop/flutter_audio_desktop.dart';


class AudioController {
  late AudioPlayer _player;
  late AudioPlayer _instance;
  bool isPlaying = false;

  AudioController() : _player = new AudioPlayer(id: 1);

  play() async {
    if (Platform.isMacOS) return;

    if (_player.audio.isPlaying) return;

    _player.load(
      await AudioSource.fromAsset('assets/audio/03265.mp3'),
    );

    _player.play();
  }

  stop() {
    if (Platform.isMacOS) return;

    if (!_player.audio.isPlaying) return;
    _player.stop();
  }
}