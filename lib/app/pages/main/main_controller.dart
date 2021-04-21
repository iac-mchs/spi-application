import 'dart:developer';

import 'package:fire_notifications_new/app/pages/main/main_presenter.dart';
import 'package:fire_notifications_new/app/pages/pages.dart';
import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart';
import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MainController extends Controller {
  late UserService? _userService;
  MainPresenter _mainPresenter;
  List<ObjectItem> objects = [];
  List<SensorStateItem> sensors = [];
  List<Notification> notifications = [];
  List<AccountDto> accounts = [];

  bool networkIsAvailable = true;

  MainController(UserService userService, ObjectsService objectsService)
      : _mainPresenter = MainPresenter(userService, objectsService) {
    initListeners();
    _mainPresenter.getObjects();
    _mainPresenter.getAccounts();
    _userService = userService;
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

      List<SensorStateItem> criticalStates = list
          .where((element) => [2, 4, 5].contains(element.lastStatus?.code))
          .toList();

      List<Notification> notifyList = [];

      for (final critical in criticalStates) {
        try {
          dynamic object =
              objects.firstWhere((element) => element.id == critical.objId);
          notifyList.add(new Notification(object, critical, critical.account));
        } catch (e) {
          throw e;
        }
      }

      notifications = notifyList;
      updateObjectState();
    };

    _mainPresenter.getNotificationsOnComplete = () {
      refreshUI();
    };

    _mainPresenter.getObjectsOnError = (e) {};
    _mainPresenter.getNotificationsOnError = (e) {};

    // get accounts
    _mainPresenter.getAccountsOnComplete = this.getAccountsOnComplete;
    _mainPresenter.getAccountsOnError = this.getAccountsOnError;
    _mainPresenter.getAccountsOnNext = this.getAccountsOnNext;

    // remove accounts
    _mainPresenter.removeAccountOnNext = this.removeAccountOnNext;
    _mainPresenter.removeAccountOnError = this.removeAccountOnError;
    _mainPresenter.removeAccountOnComplete = this.removeAccountOnComplete;
  }

  void onReassembled() {
    super.onReassembled();
    _mainPresenter.getObjects();
  }

  void stopTimer() => _mainPresenter.disableTimer();
  void removeAccount(AccountDto account) => _mainPresenter.removeAccount(account);

  Future<int> accountsCount() async {
    dynamic acc = await DataUserService.getAccounts();
    return acc.length;
  }

  void updateObjectState() {
    for (final object in objects) {
      dynamic objectSensors =
          sensors.where((element) => element.objId == object.id).toList();
      object.sensors = objectSensors;
    }
  }

  void getAccountsOnComplete() {
    refreshUI();
  }

  void getAccountsOnNext(List<AccountDto> data) {
    accounts = data;
  }

  void getAccountsOnError(e) {
    throw e;
  }

  // remove acc

  void removeAccountOnComplete() {
    this.stopTimer();

    if (accounts.length == 0) {
      Navigator.of(getContext()).pushNamed(Pages.authentication);
      return;
    }

    refreshUI();
    Navigator.of(getContext()).pushNamed(Pages.notificationScreen);
  }

  void removeAccountOnNext(List<AccountDto> available) {
    accounts = available;
  }

  void removeAccountOnError(e) {
    throw e;
  }
}
