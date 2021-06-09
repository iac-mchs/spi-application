
import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';

class AudioController {
  late Player _player;
  bool isPlaying = false;

  AudioController() : _player = new Player(id: 1);

  play() async {
    if (Platform.isMacOS) return;

    if (isPlaying) return;

    Media media = await Media.asset('assets/audio/03265.mp3');
    _player.open(
      new Playlist(medias: [media], playlistMode: PlaylistMode.loop),
      autoStart: false,
    );

    _player.play();
    isPlaying = true;
  }

  stop() {
    if (Platform.isMacOS) return;

    if (!isPlaying) return;
    _player.stop();
    isPlaying = false;
  }
}