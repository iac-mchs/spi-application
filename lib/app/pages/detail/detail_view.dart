import 'package:fire_notifications_new/app/components/default_button.dart';
import 'package:fire_notifications_new/app/components/labeled_text_field.dart';
import 'package:fire_notifications_new/app/components/map_view.dart';
import 'package:fire_notifications_new/app/components/tab_button_widget.dart';
import 'package:fire_notifications_new/app/pages/detail/detail_controller.dart';
import 'package:fire_notifications_new/app/pages/detail/utils/info_tab_page.dart';
import 'package:fire_notifications_new/app/pages/detail/utils/sensors_tab_page.dart';
import 'package:fire_notifications_new/app/pages/detail/utils/top_side_container.dart';
import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/data/services/data_objects_service.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart' as C;
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DetailPage extends View {
  final C.Notification notification;

  DetailPage({required Key key, required this.notification}) : super(key: key);

  DetailPageView createState() => DetailPageView();
}

class DetailPageView extends ResponsiveViewState<DetailPage, DetailController> {
  DetailPageView() : super(DetailController(DataObjectsService()));

  Widget get sensorsPage => Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Text('sensors'),
      );

  Widget get pagesContainer => ControlledWidgetBuilder<DetailController>(
        builder: (context, controller) {
          return Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                pageSnapping: false,
                controller: controller.pageController,
                children: <Widget>[
                  InfoTabPage(notification: this.widget.notification),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: SensorsTabPage(notification: this.widget.notification))
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

  @override
  // TODO: implement desktopView
  Widget get desktopView => Container(
        key: globalKey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height,
                  child: MapView(this.widget.notification),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TopSideContainer(this.widget.notification),
                    pagesContainer,
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  @override
  // TODO: implement mobileView
  Widget get mobileView => throw UnimplementedError();

  @override
  // TODO: implement tabletView
  Widget get tabletView => throw UnimplementedError();

  @override
  // TODO: implement watchView
  Widget get watchView => throw UnimplementedError();
}
