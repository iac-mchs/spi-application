
import 'dart:ui';

import 'package:fire_notifications_new/app/components/notification_item.dart';
import 'package:fire_notifications_new/app/pages/main/main_controller.dart';
import 'package:fire_notifications_new/data/services/data_objects_service.dart';
import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainPage extends View {
  MainPage({required Key key}) : super(key: key);

  MainPageView createState() => MainPageView();
}

class MainPageView extends ViewState<MainPage, MainController> {

  MainPageView() : super(MainController(DataUserService(), DataObjectsService()));

  Positioned get background => Positioned(
    top: 0.0,
    left: 0.0,
    right: 0.0,
    height: MediaQuery.of(context).size.height,
    child: Image.asset('assets/img/bg.png', fit: BoxFit.cover),
  );

  Widget get networkStatus => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.4),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: Text(
              'Подключение активно',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, fontFamily: 'Roboto', color: Colors.green),
            ),
          )
        ],
      ),
    ),
  );

  Widget get popupMenu => Padding(
    padding: EdgeInsets.only(left: 12.0, right: 12.0),
    child: PopupMenuButton(
      child: Text('asd'),
      itemBuilder: (context) {
        return List.generate(5, (index) => PopupMenuItem(child: Text('ttt $index')));
      },
      onSelected: (value) {},
    ),
  );

  Widget get rightMenu => ControlledWidgetBuilder<MainController>(
      builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 12.0, left: 12.0),
          child: Row(
            children: [
              Text(
                'Объектов на контроле: ${controller.objects.length}, Датчиков: ${controller.sensors.length}',
                style: TextStyle(color: Color(0xFF01437b), fontFamily: 'Roboto', fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }
  );

  Widget get topbar => Positioned(
    left: 0.0,
    top: 0.0,
    right: 0.0,
    height: 50.0,
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          networkStatus,
          rightMenu,
        ],
      ),
    ),
  );

  Widget get waitingSpinner => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: SpinKitDoubleBounce(color: Color(0xFFA2BBCC), size: 18, duration: Duration(milliseconds: 1800)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: SpinKitDoubleBounce(color: Color(0xFFA2BBCC), size: 18, duration: Duration(milliseconds: 1900)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: SpinKitDoubleBounce(color: Color(0xFFA2BBCC), size: 18, duration: Duration(milliseconds: 2000)),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(top: 24),
        child: Text(
          'В данный момент тревог не обнаружено',
          style: new TextStyle(
            color: Color(0xFF9CA9B2),
            fontSize: 28,
          ),
        ),
      ),
    ],
  );

  Widget get body => Positioned(
    right: 0,
    left: 0,
    top: 0,
    bottom: 0,
    child: ControlledWidgetBuilder<MainController>(
      builder: (context, controller) {
        return Container(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 4,
            right: MediaQuery.of(context).size.width / 4,
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
                    child: controller.notifications.isNotEmpty ? ListView(
                      physics: new AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      children: [
                        for (final notification in controller.notifications) ... [
                          new NotificationItem(notification: notification)
                        ]
                      ],
                    ) : waitingSpinner,
                  ),
                )
              )
            ],
          ),
        );
      },
    ),
  );

  @override
  // TODO: implement view
  Widget get view => Scaffold(
    key: globalKey,
    body: Stack(
      children: <Widget>[
        topbar,
        background,
        body,
      ],
    ),
  );
}