import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Routes {
  static String get splash => '/splash';
  static String get onBoarding => '/onBoarding';
  static String get signIn => '/signIn';
  static String get signUp => '/signUp';
  static String get main => '/main';
  static String get profileTab => '/profileTab';
  static String get terms => '/terms';
  static String get privacy => '/privacy';
  static String get changeName => '/changeName';
  static String get changePassword => '/changePassword';
  static String get changeAvatar => '/changeAvatar';
  static String get homeTab => '/homeTab';
  static String get project => '/project';
  static String get scheduleTab => '/scheduleTab';
  static String get notificationTab => '/notificationTab';
  static String get task => '/task';
  static String get meeting => '/meeting';
  static String get meetingRoom => '/meetingRoom';

  static getRoute(RouteSettings settings) {
    Widget widget;
    try {
      widget = GetIt.I.get<Widget>(instanceName: settings.name);
    } catch (e) {
      widget = Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Builder(
            builder: (context) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                child: Text(
                  '404 NOT FOUND',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      );
    }
    return CupertinoPageRoute(builder: (_) => widget, settings: settings);
  }
}
