import 'dart:developer';

import 'package:fire_notifications_new/app/pages/main/main_presenter.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart';
import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MainController extends Controller {
  MainPresenter _mainPresenter;
  List<ObjectItem> objects = [];
  List<SensorStateItem> sensors = [];
  List<Notification> notifications = [];

  bool networkIsAvailable = true;

  MainController(UserService userService, ObjectsService objectsService)
      : _mainPresenter = MainPresenter(userService, objectsService) {
    initListeners();
    _mainPresenter.getObjects();
  }

  @override
  void initListeners() {
    _mainPresenter.getObjectsOnNext = (List<ObjectItem> list) {
      objects = list;
    };

    _mainPresenter.getObjectsOnComplete = () {
      refreshUI();
    };

    _mainPresenter.getNotificationsOnNext = (List<SensorStateItem> list) {
      sensors = list;

      List<SensorStateItem> criticalStates = list.where((element) => [2, 4, 5].contains(element.lastStatus?.code)).toList();

      List<Notification> notifyList = [];

      for (final critical in criticalStates) {
        notifyList.add(
          new Notification(
            objects.firstWhere((element) => element.id == critical.objId),
            critical,
            critical.account
          )
        );
      }

      notifications = notifyList;
      updateObjectState();
    };

    _mainPresenter.getNotificationsOnComplete = () {
      refreshUI();
    };

    _mainPresenter.getObjectsOnError = (e) {};
    _mainPresenter.getNotificationsOnError = (e) {};
  }

  void updateObjectState() {
    for (final object in objects) {
      dynamic objectSensors = sensors.where((element) => element.objId == object.id).toList();
      object.sensors = objectSensors;
    }
  }
}