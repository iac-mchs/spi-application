
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioController extends ChangeNotifier {
  final AudioCache _cache = new AudioCache(prefix: 'assets/audio/');
  late AudioPlayer? _instance;
  bool isPlaying = false;

  void play() async {
    if (isPlaying) return;
    _instance = await _cache.loop('03265.mp3');
    isPlaying = true;

    notifyListeners();
  }

  void stop() async {
    if (_instance == null) return;
    _instance!.stop();
    isPlaying = false;

    notifyListeners();
  }
}