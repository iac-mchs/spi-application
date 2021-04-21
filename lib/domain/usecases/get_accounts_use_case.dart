import 'dart:async';

import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetAccountsUseCase extends UseCase<List<AccountDto>, void> {
  @override
  Future<Stream<List<AccountDto>?>> buildUseCaseStream(void params) async {
    // ignore: close_sinks
    final StreamController<List<AccountDto>> controller = new StreamController();

    try {
      dynamic accounts = await DataUserService.getAccounts();
      controller.add(accounts);
    } catch (e, stacktrace) {
      controller.addError(e, stacktrace);
    }

    return controller.stream;
  }
}