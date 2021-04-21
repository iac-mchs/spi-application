import 'dart:async';

import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class SendAckUseCase extends CompletableUseCase<SendAckUseCaseParams> {
  ObjectsService _objectsService;

  SendAckUseCase(this._objectsService);

  @override
  Future<Stream<void>> buildUseCaseStream(SendAckUseCaseParams? params) async {
    final StreamController controller = StreamController();

    try {
      await _objectsService.sendAck(params!.objectId, params.account);
      controller.close();
    } catch (e, stacktrace) {
      controller.addError(e, stacktrace);
    }

    return controller.stream;
  }

}

class SendAckUseCaseParams {
  AccountDto account;
  int objectId;

  SendAckUseCaseParams(this.account, this.objectId);
}