import 'package:fire_notifications_new/domain/entities/object_item_contact.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:xml/xml.dart';

class ObjectItem {
  final int? id;
  final String? name;
  final String? type;
  final String? address;
  final String? systemInfo;
  final String? desc;
  final String? additionalInfo;
  final double lat;
  final double lon;
  final String? att1;
  final List<ObjectItemContact>? contacts;
  List<SensorStateItem> sensors = [];

  ObjectItem({
    this.id,
    this.name,
    this.address,
    this.att1,
    this.contacts,
    this.type,
    this.systemInfo,
    this.additionalInfo,
    this.desc,
    required this.lat,
    required this.lon,
  });

  factory ObjectItem.fromXml(XmlElement node) {
    var object = ObjectItem(
      id: int.parse(node.getAttribute('id').toString()),
      name: node.getAttribute('name').toString(),
      address: node.getAttribute('address').toString(),
      type: node.getAttribute('type').toString(),
      systemInfo: node.getAttribute('protectionSystemsInfo').toString(),
      desc: node.getAttribute('desc').toString(),
      lat: double.parse(node.getAttribute('lat').toString()),
      lon: double.parse(node.getAttribute('lon').toString()),
      additionalInfo: node.getAttribute('addInfo').toString(),
      contacts: [],
    );

    var contacts = node.findAllElements('Contacts');
    for (final contactNode in contacts) {
      object.contacts!.add(ObjectItemContact(
          contactNode.getAttribute('fio').toString(),
          contactNode.getAttribute('phone').toString()));
    }

    return object;
  }
}
