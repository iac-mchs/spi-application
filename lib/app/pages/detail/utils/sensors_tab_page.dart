import 'package:fire_notifications_new/app/components/labeled_text_field.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart';
import 'package:fire_notifications_new/domain/entities/sensor_state_item.dart';
import 'package:flutter/material.dart' hide Notification;

class SensorsTabPage extends StatelessWidget {
  final Notification notification;

  SensorsTabPage({required this.notification});

  Widget sensorItem(SensorStateItem sensor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sensor.id.toString(),
                style: TextStyle(fontFamily: 'Roboto', fontSize: 32.0, fontWeight: FontWeight.w600, decoration: TextDecoration.none, color: Color(0xFF27516F)),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(6.0)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final status in sensor.statuses) ... [
                  LabeledTextField(
                    status.hDate,
                    text: status.codeTitle,
                    textColor: sensor.lastStatus == status ? status.color : status.color.withOpacity(0.2),
                    labelColor: sensor.lastStatus == status ? Color(0xFF27516F) : Color(0xFF27516F).withOpacity(0.2),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              shrinkWrap: true,
              itemCount: notification.object.sensors.length,
              itemBuilder: (context, position) {
                return sensorItem(notification.object.sensors[position]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
