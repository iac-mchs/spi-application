import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';

const REMOVE_CODES = [1, 3];
const NORMAL_CODES = [6];
const WARN_CODES = [2];
const ERROR_CODES = [4, 5];

class Notification {
  ObjectItem object;
  SensorStateItem sensor;
  // String token;
  AccountDto account;

  String get type {
    if (WARN_CODES.contains(sensor.lastStatus?.code)) {
      return 'warn';
    }

    if (ERROR_CODES.contains(sensor.lastStatus?.code)) {
      return 'error';
    }

    return 'normal';
  }

  Notification(this.object, this.sensor, this.account);
}
