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
              profileTabBloc: injector(),
            ),
        instanceName: Routes.main);
    injector.registerFactory<Widget>(() => ProfileTabPage(bloc: injector()), instanceName: Routes.profileTab);
    injector.registerFactory<Widget>(() => const TermsAndConditionsPage(), instanceName: Routes.terms);
    injector.registerFactory<Widget>(() => const PrivacyAndPolicyPage(), instanceName: Routes.privacy);
    injector.registerFactory<Widget>(() => ChangeNamePage(bloc: injector()), instanceName: Routes.changeName);
    injector.registerFactory<Widget>(() => ChangePasswordPage(bloc: injector()), instanceName: Routes.changePassword);
  }
}
