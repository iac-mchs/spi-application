import 'dart:developer';

import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/data/dtos/ack_request_dto.dart';
import 'package:fire_notifications_new/data/dtos/objects_ids_response_dto.dart';
import 'package:fire_notifications_new/data/dtos/objects_request_dto.dart';
import 'package:fire_notifications_new/data/dtos/states_request_dto.dart';
import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:fire_notifications_new/data/utils/wsdl_helper.dart';
import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:fire_notifications_new/domain/entities/state_item.dart';
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class DataObjectsService implements ObjectsService {
  @override
  Future<List<ObjectItem>> getObjectsList() async {
    List<AccountDto> accounts = await DataUserService.getAccounts();
    List<ObjectItem> finalList = [];

    if (accounts.isNotEmpty) {
      for (final account in accounts) {
        List<ObjectItem> objList = [];

        try {
          XmlDocument idsDoc = await new WSDLHelper(endpoint: account.url, token: account.token).post(
              ObjectsRequestDto().toXml(), 'GetObjects'
          );

          var response = ObjectsIdsResponseDto.fromXml(idsDoc);
          XmlDocument doc = await new WSDLHelper(endpoint: account.url, token: account.token).post(
            ObjectsRequestDto(ids: response.ids).toXml(), 'GetObjects'
          );

          var objs = doc.findAllElements('ObjDesc');
          for (final obj in objs) {
            objList.add(ObjectItem.fromXml(obj));
          }

          finalList.addAll(objList);
          print(account);
        } catch (e) {
          throw e;
        }
      }
    }

    return finalList;
  }

  @override
  Future<List<SensorStateItem>> getStates(List<ObjectItem> objects) async {
    List<AccountDto> accounts = await DataUserService.getAccounts();
    List<SensorStateItem> finalList = [];

    if (accounts.isNotEmpty) {
      for (final account in accounts) {
        var objIds = ObjectsIdsResponseDto.fromXml(await new WSDLHelper(endpoint: account.url, token: account.token).post(
            ObjectsRequestDto().toXml(), 'GetObjects'
        ));

        XmlDocument doc = await new WSDLHelper(endpoint: account.url, token: account.token).post(
            StatesRequestDto(objIds.ids).toXml(), 'GetCurrentState'
        );

        Iterable<XmlNode> objNode = doc.findAllElements('ObjState');

        for (final obj in objNode) {
          Iterable<XmlNode> sensorNodes = obj.findAllElements('Sensor');

          for (final sensor in sensorNodes) {
            finalList.add(SensorStateItem.fromXmlNode(sensor, int.parse(obj.getAttribute('id').toString()), account));
          }
        }
      }
    }

    return finalList;
  }

  Future<void> sendAck(int objId, AccountDto account) async {
    await new WSDLHelper(endpoint: account.url, token: account.token)
      .post(new AckRequestDto(objId).toXml(), 'SendAck');
  }
}
