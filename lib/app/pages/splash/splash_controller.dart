import 'package:fire_notifications_new/app/pages/pages.dart';
import 'package:fire_notifications_new/app/pages/splash/splash_presenter.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class SplashController extends Controller {
  bool isLoading = false;

  SplashPresenter? _splashPresenter;

  SplashController(userService)
    : _splashPresenter = SplashPresenter(userService) {
    getAuthStatus();
  }

  void authStatusOnNext(bool isAuth) {
    String page = isAuth ? Pages.notificationScreen : Pages.authentication;
    Navigator.of(getContext()).pushReplacementNamed(page);
  }

  void getAuthStatus() async {
    isLoading = true;
    Future.delayed(Duration(seconds: 3), () {
      _splashPresenter!.getAuthStatus();
    });
  }

  @override
  void initListeners() {
    _splashPresenter!.getAuthStateOnNext = authStatusOnNext;
    _splashPresenter!.getAuthStateOnComplete = () => isLoading = false;
  }

  void dispose() => _splashPresenter!.dispose();
}