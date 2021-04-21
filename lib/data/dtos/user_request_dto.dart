import 'package:fire_notifications_new/domain/dtos/xml_request_dto.dart';
import 'package:xml/xml.dart';

class UserRequestDto implements XmlRequestDto {
  XmlElement toXml() {
    final xml = new XmlBuilder();

    xml.element('fir:login');

    return xml.buildDocument().rootElement;
  }
}