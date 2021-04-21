import 'dart:developer';

import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:fire_notifications_new/domain/usecases/authenticate_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AuthenticationPresenter extends Presenter {
  UserService? _userService;
  AuthenticateUseCase? _authenticateUseCase;

  Function? loginOnComplete;
  Function? loginOnError;

  AuthenticationPresenter(this._userService) {
    _authenticateUseCase = AuthenticateUseCase(_userService!);
  }

  void dispose() {
    _authenticateUseCase!.dispose();
  }

  void login({required String url, required String username, required String password}) {
    _authenticateUseCase!.execute(_AuthenticateUseCaseObserver(this),
        AuthenticateUseCaseParams(url, username, password));
  }
}

class _AuthenticateUseCaseObserver implements Observer<void> {
  AuthenticationPresenter _authenticationPresenter;

  _AuthenticateUseCaseObserver(this._authenticationPresenter);

  void onNext(ignore) {}

  @override
  void onComplete() {
    _authenticationPresenter.loginOnComplete!();
  }

  void onError(e) {
    if (_authenticationPresenter.loginOnError != null) {
      _authenticationPresenter.loginOnError!(e);
    }
  }
}
