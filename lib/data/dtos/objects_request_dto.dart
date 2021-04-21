import 'package:fire_notifications_new/domain/dtos/xml_request_dto.dart';
import 'package:xml/xml.dart';

class ObjectsRequestDto implements XmlRequestDto {
  late List<int>? ids = [];
  // final int userId;

  ObjectsRequestDto({ this.ids });

  XmlElement toXml() {
    final xml = new XmlBuilder();

    xml.element('ns:GetObjectsReq', nest: () {
      if (ids != null && ids!.isNotEmpty) {
        for (final objectId in ids!) {
          xml.element('Obj', attributes: { 'id': objectId.toString() });
        }
      }
    });

    return xml.buildDocument().rootElement;
  }
}