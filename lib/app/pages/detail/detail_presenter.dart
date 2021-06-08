import 'package:event_bus/event_bus.dart';
import 'package:fire_notifications_new/app/globals.dart';
import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/domain/events/stop_sound_event.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:fire_notifications_new/domain/usecases/send_ack_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DetailPresenter extends Presenter {
  final SendAckUseCase sendAckUseCase;

  late ObjectsService _objectsService;

  late Function ackOnComplete;
  late Function ackOnError;

  DetailPresenter(ObjectsService objectsService)
      : sendAckUseCase = SendAckUseCase(objectsService) {
    this._objectsService = objectsService;
  }

  void dispose() {
    sendAckUseCase.dispose();
  }

  void sendAck(int objId, AccountDto account) => sendAckUseCase.execute(
      _SendAckUseCaseObserver(this), SendAckUseCaseParams(account, objId));
}

class _SendAckUseCaseObserver extends Observer<void> {
  DetailPresenter _detailPresenter;

  _SendAckUseCaseObserver(this._detailPresenter);

  void onNext(void ignore) {}

  @override
  void onComplete() {
    _detailPresenter.ackOnComplete();
    eventBus.fire(StopSoundEvent());
  }

  @override
  void onError(e) {
    _detailPresenter.ackOnError(e);
  }
}
