import 'package:fire_notifications_new/app/components/labeled_text_field.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart' as C;
import 'package:flutter/material.dart';

class InfoTabPage extends StatelessWidget {
  final C.Notification notification;

  InfoTabPage({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LabeledTextField('Описание',
              text: notification.object.desc,
              textColor: Colors.black,
              labelColor: Color(0xFF27516F)),
          LabeledTextField('Информация о системе',
              text: notification.object.systemInfo,
              textColor: Colors.black,
              labelColor: Color(0xFF27516F)),
          LabeledTextField('Дополнительная информация',
              text: notification.object.additionalInfo,
              textColor: Colors.black,
              labelColor: Color(0xFF27516F)),
          Padding(padding: EdgeInsets.only(bottom: 16.0)),
          if (notification.object.contacts != null) ...[
            Text('Контакты',
                style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    decoration: TextDecoration.none)),
            Padding(padding: EdgeInsets.only(bottom: 8.0)),
            for (final contact in notification.object.contacts!) ...[
              LabeledTextField(
                contact.name,
                text: contact.phone,
                textColor: Colors.black,
                labelColor: Color(0xFF27516F),
              )
            ]
          ]
        ],
      ),
    );
  }
}
