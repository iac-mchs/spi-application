
import 'dart:async';

import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:fire_notifications_new/domain/entities/state_item.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class NotificationsUseCase extends UseCase<List<SensorStateItem>, NotificationsUseCaseParams> {
  ObjectsService _objectsService;

  NotificationsUseCase(this._objectsService);

  @override
  Future<Stream<List<SensorStateItem>?>> buildUseCaseStream(NotificationsUseCaseParams? params) async {
    final StreamController<List<SensorStateItem>> controller = new StreamController();

    try {
      controller.add(
        await this._objectsService.getStates(params!._objects)
      );
      controller.close();
    } catch (e) {
      controller.addError(e);
    }

    return controller.stream;
  }
}

class NotificationsUseCaseParams {
  List<ObjectItem> _objects;

  NotificationsUseCaseParams(this._objects);
}