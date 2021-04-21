import 'package:xml/xml.dart';

class ObjectsIdsResponseDto {
  final List<int> ids;

  ObjectsIdsResponseDto({ required this.ids });

  factory ObjectsIdsResponseDto.fromXml(XmlDocument document) {
    List<int> values = [];

    var objects = document.findAllElements('Obj');
    if (objects.isEmpty) {
      throw Error();
    }

    for (final objectNode in objects) {
      values.add(int.parse(objectNode.getAttribute('id').toString()));
    }

    return ObjectsIdsResponseDto(ids: values);
  }
}