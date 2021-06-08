import 'dart:developer';

import 'package:fire_notifications_new/app/globals.dart';
import 'package:fire_notifications_new/domain/events/network_status_event.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

/// Сервис, который оборачивает все в единый XML документ и шлет POST запросом до WSDL (SOAP) сервиса.
class WSDLHelper {
  final String endpoint;
  final String token;

  WSDLHelper({ required this.endpoint, required this.token });

  // static const endpoint =
  //    'http://192.168.18.145:8588/FireNotificationWS/services/fireNotification';

  Future<XmlDocument> post(XmlElement request, String method) async {
    String requestBody = _soapEnvelope(request).toString();
    Map<String, String> headers = {
      'Content-Type': 'text/xml',
    };

    headers['SOAPAction'] = method.isNotEmpty
        ? 'urn:$method'
        : '';
    headers['Authorization'] = "Basic $token";

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: requestBody,
      );

      if ([401, 403].contains(response.statusCode)) {
        throw new Exception('Неверные данные для входа.');
      }

      if ([500].contains(response.statusCode)) {
        eventBus.fire(NetworkStatusEvent(false));
        throw new Exception('Ошибка сервера.');
      }

      if ([404].contains(response.statusCode)) {
        throw new Exception('Сервис или метод не найдены (404)');
      }

      String responseBody = response.body;

      XmlDocument document = XmlDocument.parse(responseBody);

      eventBus.fire(NetworkStatusEvent(true));

      return document;
    } catch (e, stacktrace) {
      eventBus.fire(NetworkStatusEvent(false));
      print(e);
      print(stacktrace);
    }

    return new XmlDocument();
  }

  static XmlNode _soapEnvelope(Object body) {
    final uri = 'http://schemas.xmlsoap.org/soap/envelope/';
    final firUri = 'urn://iac-mchs-ru/services/spi/1.1';
    final xml = XmlBuilder();
    xml.element("Envelope", namespace: uri, nest: () {
      xml.namespace(uri, 'soapenv');
      xml.namespace(firUri, 'ns');
      xml.element("Header", namespace: uri);
      xml.element("Body", namespace: uri, nest: body);
    });
    return xml.buildDocument();
  }
}
