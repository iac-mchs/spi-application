import 'package:fire_notifications_new/app/pages/pages.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class AppRouter {
  final RouteObserver<PageRoute> routeObserver;

  AppRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic>? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.authentication:
        Map<dynamic, dynamic> args = settings.arguments != null ? settings.arguments as Map : {};
        return _buildRoute(settings, AuthenticationPage(key: Key('authentication'), isAdding: args['isAdding'] ?? false,));
      case Pages.notificationScreen:
        return _buildRoute(settings, MainPage(key: Key('main')));
      case Pages.detailPage:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, DetailPage(
          key: Key('detail'),
          notification: args['notification'],
        ));
      default:
        return null;
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (context) => builder,
    );
  }
}
