import 'dart:async';
import 'dart:io';

import 'package:fire_notifications_new/app/globals.dart';
import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:fire_notifications_new/domain/entities/state_item.dart';
import 'package:fire_notifications_new/domain/events/network_status_event.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:fire_notifications_new/domain/usecases/get_accounts_use_case.dart';
import 'package:fire_notifications_new/domain/usecases/get_objects_use_case.dart';
import 'package:fire_notifications_new/domain/usecases/notifications_use_case.dart';
import 'package:fire_notifications_new/domain/usecases/remove_account_use_case.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MainPresenter extends Presenter {
  final NotificationsUseCase notificationsUseCase;
  final GetObjectsUseCase getObjectsUseCase;
  final GetAccountsUseCase getAccountsUseCase;
  final RemoveAccountUseCase removeAccountUseCase;

  late Function getObjectsOnNext;
  late Function getObjectsOnComplete;
  late Function getObjectsOnError;

  late Function getNotificationsOnComplete;
  late Function getNotificationsOnNext;
  late Function getNotificationsOnError;

  late Function getAccountsOnComplete;
  late Function getAccountsOnNext;
  late Function getAccountsOnError;

  late Function removeAccountOnComplete;
  late Function removeAccountOnNext;
  late Function removeAccountOnError;

  late ObjectsService _objectsService;

  Timer? notificationTimer;

  MainPresenter(UserService userService, ObjectsService objectsService)
      : notificationsUseCase = NotificationsUseCase(objectsService),
        getObjectsUseCase = GetObjectsUseCase(objectsService),
        getAccountsUseCase = GetAccountsUseCase(),
        removeAccountUseCase = RemoveAccountUseCase() {
    this._objectsService = objectsService;
  }

  void startNotificationsListener(objects) {
    notificationTimer = Timer.periodic(new Duration(seconds: 5), (timer) async {
      notificationsUseCase.execute(_NotificationsUseCaseObserver(this),
          NotificationsUseCaseParams(objects));
    });
    notificationsUseCase.execute(_NotificationsUseCaseObserver(this),
        NotificationsUseCaseParams(objects));
  }

  @override
  void dispose() {
    notificationsUseCase.dispose();
    getObjectsUseCase.dispose();
    getAccountsUseCase.dispose();

    if (notificationTimer != null && notificationTimer!.isActive) {
      notificationTimer!.cancel();
    }
  }

  void getObjects() => getObjectsUseCase.execute(_GetObjectsObserver(this));
  void getAccounts() => getAccountsUseCase.execute(_GetAccountsObserver(this));
  void removeAccount(AccountDto account) => removeAccountUseCase.execute(
      _RemoveAccountObserver(this), RemoveAccountUseCaseParams(account));

  void disableTimer() {
    if (notificationTimer != null) {
      notificationTimer!.cancel();
    }
  }
}

class _NotificationsUseCaseObserver implements Observer<List<SensorStateItem>> {
  final MainPresenter _presenter;
  _NotificationsUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getNotificationsOnComplete();
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

class _GetAccountsObserver implements Observer<List<AccountDto>> {
  MainPresenter _presenter;

  _GetAccountsObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getAccountsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getAccountsOnError(e);
  }

  @override
  void onNext(List<AccountDto>? response) {
    _presenter.getAccountsOnNext(response);
  }
}

class _RemoveAccountObserver implements Observer<List<AccountDto>> {
  MainPresenter _presenter;

  _RemoveAccountObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.removeAccountOnComplete();
  }

  @override
  void onError(e) {
    _presenter.removeAccountOnError(e);
  }

  @override
  void onNext(list) {
    _presenter.removeAccountOnNext(list);
  }
}
