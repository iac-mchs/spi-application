import 'dart:developer';
import 'dart:io';

import 'package:fire_notifications_new/app/pages/authentication/authentication_presenter.dart';
import 'package:fire_notifications_new/app/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AuthenticationController extends Controller {
  late TextEditingController usernameTextController;
  late TextEditingController passwordTextController;
  late TextEditingController urlTextController;

  AuthenticationPresenter _authenticationPresenter;
  bool isLoading = false;

  AuthenticationController(userService)
      : _authenticationPresenter = AuthenticationPresenter(userService) {
    usernameTextController = TextEditingController();
    passwordTextController = TextEditingController();
    urlTextController = TextEditingController();
    initListeners();
  }

  @override
  void initListeners() {
    _authenticationPresenter.loginOnComplete = this._loginOnComplete;
    _authenticationPresenter.loginOnError = this._loginOnError;
  }

  void _loginOnComplete() {
    dismissLoading();
    Navigator.of(getContext()).pushReplacementNamed(Pages.notificationScreen);
  }

  void _loginOnError(e) {
    dismissLoading();

    ScaffoldMessenger.of(getContext()).showSnackBar(SnackBar(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      backgroundColor: Colors.red,
      content: Text(
        e.toString(),
        style: TextStyle(
            fontFamily: 'Roboto', fontWeight: FontWeight.w500, fontSize: 17.0),
      ),
    ));
  }

  void login() async {
    isLoading = true;
    refreshUI();
    _authenticationPresenter.login(
        url: urlTextController.text,
        username: usernameTextController.text,
        password: passwordTextController.text);
  }

  void dismissLoading() {
    isLoading = false;
    refreshUI();
  }
}
