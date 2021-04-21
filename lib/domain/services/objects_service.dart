import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:fire_notifications_new/domain/entities/state_item.dart';

abstract class ObjectsService {
  Future<List<ObjectItem>> getObjectsList();
  Future<List<SensorStateItem>> getStates(List<ObjectItem> objects);
  Future<void> sendAck(int objId, AccountDto account);
}