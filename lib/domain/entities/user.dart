import 'package:xml/xml.dart';

class User {
  final int userId;

  User(this.userId);

  User.from(User user)
    : userId = user.userId;

  factory User.fromXml(XmlDocument document) {
    final data = document.findAllElements('UserId').map((node) => node.text);
    return User(int.parse(data.first));
  }
}