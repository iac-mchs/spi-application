import 'package:fire_notifications_new/domain/dtos/xml_request_dto.dart';
import 'package:fire_notifications_new/domain/entities/object_item.dart';
import 'package:xml/xml.dart';

class StatesRequestDto implements XmlRequestDto {
  List<int> objects;

  StatesRequestDto(this.objects);

  XmlElement toXml() {
    var xml = XmlBuilder();

    xml.element('ns:GetCurrentStateReq', nest: () {
      for (final object in objects) {
        xml.element('Obj', attributes: { 'id': object.toString() });
      }
    });

    return xml.buildDocument().rootElement;
  }
}