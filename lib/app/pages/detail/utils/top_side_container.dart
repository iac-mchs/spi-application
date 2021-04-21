import 'package:fire_notifications_new/app/components/default_button.dart';
import 'package:fire_notifications_new/app/components/labeled_text_field.dart';
import 'package:fire_notifications_new/app/components/tab_button_widget.dart';
import 'package:fire_notifications_new/app/pages/detail/detail_controller.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class TopSideContainer extends StatelessWidget {
  final Notification notification;

  TopSideContainer(this.notification);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF395E83), Color(0xFF698EB2)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 23.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Объект',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
              Text(
                notification.object.name!,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
              Padding(padding: EdgeInsets.only(bottom: 15.0)),
              LabeledTextField('Статус',
                  text: notification.sensor.lastStatus!.codeTitle,
                  textColor: notification.sensor.lastStatus!.color),
              LabeledTextField('Адрес', text: notification.object.address!),
              LabeledTextField('Датчиков на объекте',
                  text: notification.object.sensors.length.toString()),
              Padding(
                padding: EdgeInsets.only(bottom: 15.0, top: 7.0),
                child: ControlledWidgetBuilder<DetailController>(
                  builder: (context, controller) {
                    return Row(
                      children: [
                        Listener(
                          onPointerUp: (void event) {
                            if (notification.type != 'error') return;
                            controller.ack(notification.object.id, notification.account);
                          },
                          child: DefaultButton(
                            notification.type == 'error'
                                ? 'Отправить наряд'
                                : notification.sensor.lastStatus!.codeTitle,
                            defaultColor: notification.type == 'error'
                                ? Color(0xFFE13131)
                                : Color(0xFFA3A3A0),
                            isDisabled: notification.type != 'error',
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              ControlledWidgetBuilder<DetailController>(
                builder: (context, controller) {
                  return Align(
                      alignment: Alignment.bottomCenter,
                      child: new ButtonTheme(
                        layoutBehavior: ButtonBarLayoutBehavior.constrained,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        child: new ButtonBar(
                          alignment: MainAxisAlignment.start,
                          buttonHeight: 33,
                          buttonMinWidth: 62,
                          buttonPadding: EdgeInsets.zero,
                          children: <Widget>[
                            TabButtonWidget(
                              0,
                              'информация',
                              controller.pageController,
                              isActive: controller.currentPageIndex == 0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 9, right: 9),
                              child: TabButtonWidget(
                                1,
                                'Датчики',
                                controller.pageController,
                                isActive: controller.currentPageIndex == 1,
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
