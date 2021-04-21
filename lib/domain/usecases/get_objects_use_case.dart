import 'dart:async';
import 'dart:developer';

import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetObjectsUseCase extends UseCase<List<ObjectItem>, void> {
  ObjectsService _objectsService;
  GetObjectsUseCase(this._objectsService);

  @override
  Future<Stream<List<ObjectItem>>> buildUseCaseStream(void params) async {
    final StreamController<List<ObjectItem>> controller = StreamController();

    try {
      List<ObjectItem> objs = await _objectsService.getObjectsList();
      controller.add(objs);
      controller.close();
    } catch (e, stacktrace) {
      controller.addError(e);
    }

    return controller.stream;
  }
}