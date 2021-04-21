import 'package:fire_notifications_new/domain/dtos/xml_request_dto.dart';
import 'package:xml/xml.dart';

class AckRequestDto implements XmlRequestDto {
  final int objectId;

  AckRequestDto(this.objectId);

  XmlElement toXml() {
    final xml = new XmlBuilder();

    xml.element('ns:SendAckReq', attributes: { 'objId': objectId.toString() });

    return xml.buildDocument().rootElement;
  }
}