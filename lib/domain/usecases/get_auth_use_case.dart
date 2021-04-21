import 'dart:async';

import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetAuthUseCase extends UseCase<bool, void> {
  UserService? _userService;

  GetAuthUseCase(this._userService);

  @override
  Future<Stream<bool>> buildUseCaseStream(void ignore) async {
    final StreamController<bool> controller = StreamController();

    try {
      bool isAuth = await _userService!.isAuthenticated();
      controller.add(isAuth);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }

    return controller.stream;
  }
}
