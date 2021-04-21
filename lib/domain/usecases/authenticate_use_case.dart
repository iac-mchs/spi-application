import 'dart:async';
import 'dart:developer';

import 'package:fire_notifications_new/domain/entities/user.dart';
import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AuthenticateUseCase extends CompletableUseCase<AuthenticateUseCaseParams> {
  UserService _userService;

  AuthenticateUseCase(this._userService);

  @override
  Future<Stream<User>> buildUseCaseStream(AuthenticateUseCaseParams? params) async {
    final StreamController<User> controller = StreamController();

    try {
      await _userService.authenticate(url: params!._url, username: params._username, password: params._password);
      controller.close();
    } catch (e, stacktrace) {
      controller.addError(e);
    }

    return controller.stream;
  }
}

class AuthenticateUseCaseParams {
  String _url;
  String _username;
  String _password;

  AuthenticateUseCaseParams(this._url, this._username, this._password);
}