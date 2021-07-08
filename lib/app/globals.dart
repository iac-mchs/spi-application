library fire_notifications_new.globals;

import 'package:event_bus/event_bus.dart';

class PlayedSensor {
  int id;
  int ts;

  PlayedSensor({required this.id, required this.ts});
}

EventBus eventBus = new EventBus();
bool networkStatus = true;

List<PlayedSensor?> playedList = [];
