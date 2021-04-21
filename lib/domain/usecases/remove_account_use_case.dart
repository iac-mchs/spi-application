import 'dart:async';

import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class RemoveAccountUseCase extends UseCase<List<AccountDto>, RemoveAccountUseCaseParams> {
  @override
  Future<Stream<List<AccountDto>>> buildUseCaseStream(RemoveAccountUseCaseParams? params) async {
    // ignore: close_sinks
    StreamController<List<AccountDto>> controller = new StreamController();

    try {
      controller.add(await DataUserService.removeAccount(params!.account));
      controller.close();
    } catch (e) {
      controller.addError(e);
    }

    return controller.stream;
  }
}

class RemoveAccountUseCaseParams {
  final AccountDto account;

  RemoveAccountUseCaseParams(this.account);
}