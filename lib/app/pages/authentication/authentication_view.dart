import 'dart:io';

import 'package:fire_notifications_new/app/components/default_button.dart';
import 'package:fire_notifications_new/app/components/ensure_focus.dart';
import 'package:fire_notifications_new/app/components/input_field.dart';
import 'package:fire_notifications_new/app/pages/authentication/authentication_controller.dart';
import 'package:fire_notifications_new/app/pages/pages.dart';
import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AuthenticationPage extends View {
  final String? title;
  bool isAdding;

  AuthenticationPage({required Key key, this.title, this.isAdding = false})
      : super(key: key);

  AuthenticationPageView createState() => AuthenticationPageView();
}

class AuthenticationPageView
    extends ViewState<AuthenticationPage, AuthenticationController> {
  final FocusNode _usernameFocus;
  final FocusNode _passwordFocus;
  final FocusNode _urlFocus;

  AuthenticationPageView()
      : _passwordFocus = FocusNode(),
        _usernameFocus = FocusNode(),
        _urlFocus = FocusNode(),
        super(AuthenticationController(DataUserService()));

  Widget component({required Widget child}) {
    return Scaffold(
      key: globalKey,
      body: child,
    );
  }

  Positioned get background => Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/img/bg.png', fit: BoxFit.cover),
      );

  Widget get linkInput => ControlledWidgetBuilder<AuthenticationController>(
        builder: (context, controller) {
          return InputField(
            controller.urlTextController,
            'Путь до сервера',
            _urlFocus,
          );
        },
      );

  Widget get usernameInput => ControlledWidgetBuilder<AuthenticationController>(
          builder: (context, controller) {
        return InputField(
          controller.usernameTextController,
          'Имя пользователя',
          _usernameFocus,
        );
      });

  Widget get passwordInput => ControlledWidgetBuilder<AuthenticationController>(
        builder: (context, controller) {
          return InputField(
            controller.passwordTextController,
            'Пароль',
            _passwordFocus,
            isPassword: true,
          );
        },
      );

  Widget get loginButton => ControlledWidgetBuilder<AuthenticationController>(
        builder: (context, controller) {
          return Listener(
            onPointerUp: (void event) {
              if (controller.urlTextController.text.isEmpty ||
                  controller.usernameTextController.text.isEmpty ||
                  controller.passwordTextController.text.isEmpty) return;
              if (controller.isLoading) return;
              controller.login();
            },
            child: DefaultButton(
                controller.isLoading ? 'Загрузка...' : 'Подключить аккаунт'),
          );
        },
      );

  Widget get cancelButton => ControlledWidgetBuilder<AuthenticationController>(
        builder: (context, controller) {
          return Listener(
            onPointerUp: (void event) {
              if (controller.isLoading) return;
              Navigator.of(context).pushNamed(Pages.notificationScreen);
            },
            child: DefaultButton(
              'Отмена',
              isDisabled: controller.isLoading,
              defaultColor: Colors.redAccent,
            ),
          );
        },
      );

  EdgeInsets get padding {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.3,
          right: MediaQuery.of(context).size.width * 0.3);
    }

    return EdgeInsets.only(left: 25.0, right: 25.0);
  }

  @override
  // TODO: implement view
  Widget get view => component(
          child: Stack(
        children: <Widget>[
          background,
          ListView(
            physics: PageScrollPhysics(),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: padding,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          linkInput,
                          usernameInput,
                          passwordInput,
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loginButton,
                                if (this.widget.isAdding) ...{
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                  ),
                                  cancelButton
                                }
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ));
}
