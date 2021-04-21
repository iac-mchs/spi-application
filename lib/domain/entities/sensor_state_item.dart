import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart';
import 'package:fire_notifications_new/domain/entities/state_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class SensorStateItem {
  int id;
  int objId;
  AccountDto account;
  late List<_SensorStateCodeItem> statuses;

  List<_SensorStateCodeItem> get sortedStatuses {
    var list = this.statuses;
    list.sort((a, b) => b.ts.compareTo(a.ts));
    return list;
  }

  _SensorStateCodeItem? get lastStatus {
    return sortedStatuses.first;
  }

  SensorStateItem(this.id, this.objId, { required this.statuses, required this.account });

  factory SensorStateItem.fromXmlNode(XmlNode node, int objId, AccountDto account) {
    SensorStateItem stateItem = new SensorStateItem(int.parse(node.getAttribute('id').toString()), objId, statuses: [], account: account);

    Iterable<XmlElement> statusNodes = node.findAllElements('Code');

    for (final status in statusNodes) {
      stateItem.statuses.add(new _SensorStateCodeItem(
        int.tryParse(status.getAttribute('id').toString()) ?? 1,
        int.tryParse(status.getAttribute('ts').toString()) ?? 0,
      ));
    }

    return stateItem;
  }
}

class _SensorStateCodeItem {
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

  Color get color {
    if (WARN_CODES.contains(code)) {
      return Color(0xFFFFC600);
    }

    if (ERROR_CODES.contains(code)) {
      return Color(0xFFE13131);
    }

    return Color(0xFF6DD400);
  }

  String get codeTitle => _codesMap[code] ?? 'none';

  String get hDate => DateFormat('dd MMMM HH:mm:ss, yyyy г.', 'ru_RU').format(DateTime.fromMillisecondsSinceEpoch(this.ts));

  _SensorStateCodeItem(this.code, this.ts);
}