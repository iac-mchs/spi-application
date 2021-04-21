import 'dart:async';
import 'dart:io';

import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:fire_notifications_new/domain/entities/state_item.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:fire_notifications_new/domain/usecases/get_objects_use_case.dart';
import 'package:fire_notifications_new/domain/usecases/notifications_use_case.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MainPresenter extends Presenter {
  final NotificationsUseCase notificationsUseCase;
  final GetObjectsUseCase getObjectsUseCase;

  late Function getObjectsOnNext;
  late Function getObjectsOnComplete;
  late Function getObjectsOnError;

  late Function getNotificationsOnComplete;
  late Function getNotificationsOnNext;
  late Function getNotificationsOnError;

  late ObjectsService _objectsService;

  late Timer notificationTimer;

  MainPresenter(UserService userService, ObjectsService objectsService)
      : notificationsUseCase = NotificationsUseCase(objectsService),
        getObjectsUseCase = GetObjectsUseCase(objectsService) {
    this._objectsService = objectsService;
  }

  void startNotificationsListener(objects) {
    notificationTimer = Timer.periodic(new Duration(seconds: 5), (timer) async {
      notificationsUseCase.execute(_NotificationsUseCaseObserver(this), NotificationsUseCaseParams(objects));
    });
    notificationsUseCase.execute(_NotificationsUseCaseObserver(this), NotificationsUseCaseParams(objects));
  }

  @override
  void dispose() {
    notificationsUseCase.dispose();
    getObjectsUseCase.dispose();
    notificationTimer.cancel();
  }

  void getObjects() => getObjectsUseCase.execute(_GetObjectsObserver(this));
}

class _NotificationsUseCaseObserver implements Observer<List<SensorStateItem>> {
  final MainPresenter _presenter;
  _NotificationsUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getObjectsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getNotificationsOnError(e);
  }

  @override
  void onNext(List<SensorStateItem>? response) {
    _presenter.getNotificationsOnNext(response);
  }
}

class _GetObjectsObserver implements Observer<List<ObjectItem>> {
  MainPresenter _mainPresenter;

  _GetObjectsObserver(this._mainPresenter);

  @override
  void onComplete() {
    _mainPresenter.getObjectsOnComplete();
  }

  @override
  void onError(e) {
    _mainPresenter.getObjectsOnError(e);
  }

  @override
  void onNext(List<ObjectItem>? response) {
    _mainPresenter.startNotificationsListener(response);
    _mainPresenter.getObjectsOnNext(response);
  }
}