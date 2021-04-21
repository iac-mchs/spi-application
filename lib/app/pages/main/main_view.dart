import 'dart:developer';
import 'dart:ui';

import 'package:fire_notifications_new/app/components/notification_item.dart';
import 'package:fire_notifications_new/app/pages/main/main_controller.dart';
import 'package:fire_notifications_new/app/pages/pages.dart';
import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/data/services/data_objects_service.dart';
import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:popover/popover.dart';

class MainPage extends View {
  MainPage({required Key key}) : super(key: key);

  MainPageView createState() => MainPageView();
}

class MainPageView extends ViewState<MainPage, MainController> {
  MainPageView()
      : super(MainController(DataUserService(), DataObjectsService()));

  Positioned get background => Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/img/bg.png', fit: BoxFit.cover),
      );

  Widget get networkStatus => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: Colors.green,
                      textBaseline: TextBaseline.ideographic),
                  children: [
                    WidgetSpan(
                        child: Icon(
                          Icons.network_check_sharp,
                          color: Colors.green,
                        ),
                        alignment: PlaceholderAlignment.middle),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    )),
                    TextSpan(text: 'Подключение активно'),
                  ]),
            ),
          )
        ],
      );

  Widget accountsList(BuildContext context, MainController controller) {
    return Scrollbar(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                clipBehavior: Clip.none,
                children: [
                  for (final account in controller.accounts) ...[
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                new Text(
                                  account.name ?? 'Неизвестный аккаунт',
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF01437b)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.removeAccount(account);
                                  },
                                  child: Icon(
                                    Icons.delete_forever,
                                    size: 21.0,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 200.0),
              child: Listener(
                onPointerUp: (e) {
                  controller.stopTimer();
                  Navigator.of(context).pushNamed(Pages.authentication, arguments: { 'isAdding': true });
                },
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Новый источник', style: TextStyle(fontFamily: 'Roboto', color: Colors.white),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF01437b)),
                    elevation: MaterialStateProperty.all(0.0),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget get popupMenu => ControlledWidgetBuilder<MainController>(
        builder: (context, controller) {
          return Listener(
            onPointerUp: (_) {
              showPopover(
                context: context,
                bodyBuilder: (context) => accountsList(context, controller),
                direction: PopoverDirection.top,
                width: 200,
                height: 180,
                arrowHeight: 10,
                arrowWidth: 20,
              );
            },
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF01437b)),
                elevation: MaterialStateProperty.all(0.0),
              ),
              onPressed: () {},
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    children: [
                      WidgetSpan(
                          child: Icon(
                            Icons.supervisor_account_outlined,
                            color: Colors.white,
                            size: 21.0,
                          ),
                          alignment: PlaceholderAlignment.middle),
                      WidgetSpan(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                      )),
                      TextSpan(
                          text: 'Источники (${controller.accounts.length})')
                    ]),
              ),
            ),
          );
        },
      );

  Widget get rightMenu =>
      ControlledWidgetBuilder<MainController>(builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 12.0, left: 12.0),
          child: Row(
            children: [
              popupMenu,
              Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0)),
              Text(
                'Объектов на контроле: ${controller.objects.length}, Датчиков: ${controller.sensors.length}',
                style: TextStyle(
                    color: Color(0xFF01437b),
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      });

  Widget get topbar => Positioned(
        left: 0.0,
        top: 0.0,
        right: 0.0,
        height: 75.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
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
                child: SpinKitDoubleBounce(
                    color: Color(0xFFA2BBCC),
                    size: 18,
                    duration: Duration(milliseconds: 1800)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: SpinKitDoubleBounce(
                    color: Color(0xFFA2BBCC),
                    size: 18,
                    duration: Duration(milliseconds: 1900)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: SpinKitDoubleBounce(
                    color: Color(0xFFA2BBCC),
                    size: 18,
                    duration: Duration(milliseconds: 2000)),
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
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 10),
                      child: controller.notifications.isNotEmpty
                          ? ListView(
                              physics: new AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              clipBehavior: Clip.none,
                              children: [
                                for (final notification
                                    in controller.notifications) ...[
                                  new NotificationItem(
                                      notification: notification)
                                ]
                              ],
                            )
                          : waitingSpinner,
                    ),
                  ))
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
            background,
            body,
            topbar,
          ],
        ),
      );
}
