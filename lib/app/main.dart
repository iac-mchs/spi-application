import 'dart:io';
import 'package:fire_notifications_new/domain/events/network_status_event.dart';

import 'globals.dart' as globals;
import 'package:event_bus/event_bus.dart';
import 'package:fire_notifications_new/app/pages/splash/splash_view.dart';
import 'package:fire_notifications_new/app/utils/audio.dart';
import 'package:fire_notifications_new/app/utils/router.dart';
import 'package:fire_notifications_new/domain/events/play_sound_event.dart';
import 'package:fire_notifications_new/domain/events/stop_sound_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:window_size/window_size.dart' as window_size;

class PlayedSensor {
  int id;
  int ts;

  PlayedSensor({required this.id, required this.ts});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  /// clean store every time if app in a debug mode
  if (kDebugMode) {
    await preferences.clear();
  }

  // set window sizes for desktop

  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    window_size.PlatformWindow window = await window_size.getWindowInfo();

    final Rect frame = Rect.fromCenter(
      center: Offset(
        window.screen!.frame.center.dx,
        window.screen!.frame.center.dy,
      ),
      width: window.screen!.frame.size.width,
      height: window.screen!.frame.size.height,
    );

    window_size.setWindowFrame(frame);
    window_size.setWindowTitle('SPI EMERCOM');

    // await DesktopWindow.setWindowSize(window.screen!.frame.size);
    // await DesktopWindow.setMaxWindowSize(window.screen!.frame.size);
    // await DesktopWindow.setMinWindowSize(window.screen!.frame.size);

    // await DesktopWindow.toggleFullScreen();
  }

  // audio player controlling
  AudioController _audioController = new AudioController();
  List<PlayedSensor?> playedList = [];

  // eventbus listeners

  globals.eventBus.on<PlaySoundEvent>().listen((event) {
    PlayedSensor? isPlayed = playedList.firstWhere(
        (element) => element!.id == event.id && element.ts == event.id,
        orElse: () => null);
    if (isPlayed != null) return;

    playedList.add(new PlayedSensor(id: event.id, ts: event.ts));
    _audioController.play();
  });

  globals.eventBus.on<StopSoundEvent>().listen((event) {
    _audioController.stop();
  });

  globals.eventBus.on<NetworkStatusEvent>().listen((event) {
    globals.networkStatus = event.status;
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _router;

  MyApp() : _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            // SizerUtil().init(constraints, orientation);
            return MaterialApp(
              title: "Система пожарного информирования",
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme:
                    GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
                fontFamily: 'Roboto',
              ),
              home: SplashPage(),
              debugShowCheckedModeBanner: false,
              onGenerateRoute: _router.getRoute,
              navigatorObservers: [_router.routeObserver],
            );
          },
        );
      },
    );
  }
}
