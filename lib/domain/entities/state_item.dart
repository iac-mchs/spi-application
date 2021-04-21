
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class StateItem {
  final int objectId;
  final List<_StateItemStatus> statuses;

  StateItem(this.objectId, this.statuses);

  factory StateItem.fromXmlNode(XmlNode node) {
    StateItem item = new StateItem(int.parse(node.getAttribute('id')!), []);

    Iterable<XmlElement> statusNodes = node.findAllElements('status');

    for (final status in statusNodes) {
      item.statuses.add(new _StateItemStatus(
        int.parse(status.getAttribute('code')!),
        int.parse(status.getAttribute('ts')!),
      ));
    }

    return item;
  }
}

// private class for item statuses
class _StateItemStatus {
  final int code;
  final int ts;

  final Map<int, String> _codesMap = {
    1: 'Ок',
    2: 'Неисправен',
    3: 'На обслуживании',
    4: 'Пожар',
    5: 'Дым',
    6: 'Взято на контроль',
  };

  String? get codeTitle => _codesMap[code] ?? null;

  String get hDate => DateFormat('dd MMMM HH:mm:ss, yyyy г.', 'ru_RU').format(DateTime.fromMillisecondsSinceEpoch(this.ts));

  _StateItemStatus(this.code, this.ts);
}