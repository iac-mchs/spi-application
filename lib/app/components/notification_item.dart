import 'package:fire_notifications_new/app/pages/pages.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/rendering.dart';

class NotificationItem extends StatelessWidget {
  final Notification notification;

  NotificationItem({required this.notification});

  Color get color {
    switch (notification.type) {
      case 'warn':
        return Color(0xFFFFC600);

      case 'error':
        return Color(0xFFE13131);

      default:
        return Color(0xFF6DD400);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(Pages.detailPage, arguments: {
            'notification': notification,
          });
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            child: Container(
                height: 115.0,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: 98,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0x45000000), width: 1),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: new Text(
                                notification.sensor.id.toString(),
                                style: new TextStyle(
                                  // height: 98.0,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    letterSpacing: -3
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 15.0)),
                      ],
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            notification.object.address ?? 'Адрес отсутствует',
                            style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w600, color: Colors.white),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          Text(
                            notification.sensor.lastStatus?.codeTitle ?? 'Неизвестный статус',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
