import 'package:fire_notifications_new/app/pages/splash/splash_controller.dart';
import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class SplashPage extends View {
  SplashPage({Key? key}) : super(key: key);

  SplashPageView createState() => SplashPageView();
}

class SplashPageView extends ViewState<SplashPage, SplashController> with SingleTickerProviderStateMixin {
  SplashPageView() : super(SplashController(DataUserService()));

  @override
  void initState() {
    super.initState();
  }

  Positioned get background => Positioned(
    top: 0.0,
    left: 0.0,
    right: 0.0,
    height: MediaQuery.of(context).size.height,
    child: new Container(
      decoration: BoxDecoration(color: Color(0xFF01437b)),
    ),
  );

  Positioned get logo => Positioned(
    top: MediaQuery.of(context).size.height / 2 - 280,
    left: 0.0,
    right: 0.0,
    child: Column(
      children: <Widget>[
        Image(
          image: AssetImage('assets/img/mchs-logo.png'),
          width: 400.0,
        ),
      ],
    ),
  );

  Stack get body => Stack(
    children: <Widget>[
      background,
      logo,
    ],
  );

  @override
  // TODO: implement view
  Widget get view => Scaffold(key: globalKey, body: body);
}