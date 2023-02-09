import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../pages/pages.dart';
import '../router/router.dart';

class PageDependencies {
  static Future setup(GetIt injector) async {
    injector.registerFactory<Widget>(() => SplashPage(injector()), instanceName: Routes.splash);
    injector.registerFactory<Widget>(() => OnBoardingPage(injector()), instanceName: Routes.onBoarding);
    injector.registerFactory<Widget>(() => SignInPage(injector()), instanceName: Routes.signIn);
    injector.registerFactory<Widget>(() => SignUpPage(injector()), instanceName: Routes.signUp);
    injector.registerFactory<Widget>(
        () => MainPage(
              bloc: injector(),
              homeTabBloc: injector(),
              profileTabBloc: injector(),
              scheduleTabBloc: injector(),
              notificationTabBloc: injector(),
              meetingBloc: injector(),
            ),
        instanceName: Routes.main);
    injector.registerFactory<Widget>(() => ProfileTabPage(bloc: injector()), instanceName: Routes.profileTab);
    injector.registerFactory<Widget>(() => const TermsAndConditionsPage(), instanceName: Routes.terms);
    injector.registerFactory<Widget>(() => const PrivacyAndPolicyPage(), instanceName: Routes.privacy);
    injector.registerFactory<Widget>(() => ChangeNamePage(bloc: injector()), instanceName: Routes.changeName);
    injector.registerFactory<Widget>(() => ChangePasswordPage(bloc: injector()), instanceName: Routes.changePassword);
    injector.registerFactory<Widget>(() => ChangeAvatarPage(bloc: injector()), instanceName: Routes.changeAvatar);
    injector.registerFactory<Widget>(() => HomeTabPage(bloc: injector()), instanceName: Routes.homeTab);
    injector.registerFactory<Widget>(() => ProjectPage(bloc: injector()), instanceName: Routes.project);
    injector.registerFactory<Widget>(() => ScheduleTabPage(bloc: injector()), instanceName: Routes.scheduleTab);
    injector.registerFactory<Widget>(() => NotificationTabPage(bloc: injector()), instanceName: Routes.notificationTab);
    injector.registerFactory<Widget>(() => TaskPage(bloc: injector()), instanceName: Routes.task);
    injector.registerFactory<Widget>(() => MeetingPage(bloc: injector()), instanceName: Routes.meeting);
    injector.registerFactory<Widget>(() => MeetingRoomPage(bloc: injector()), instanceName: Routes.meetingRoom);
  }
}
