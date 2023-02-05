import '../blocs/blocs.dart';
import 'package:get_it/get_it.dart';

class BlocDependencies {
  static Future setup(GetIt injector) async {
    injector.registerFactory<SplashBloc>(() => SplashBloc());
    injector.registerFactory<OnBoardingBloc>(() => OnBoardingBloc());
    injector.registerFactory<SignInBloc>(() => SignInBloc(injector()));
    injector.registerFactory<SignUpBloc>(() => SignUpBloc(injector()));
    injector.registerFactory<MainBloc>(() => MainBloc());
    injector.registerFactory<ProfileTabBloc>(() => ProfileTabBloc(injector(), injector()));
    injector.registerFactory<ChangeNameBloc>(() => ChangeNameBloc(injector(), injector()));
    injector.registerFactory<ChangePasswordBloc>(() => ChangePasswordBloc(injector(), injector()));
    injector.registerFactory<ChangeAvatarBloc>(() => ChangeAvatarBloc(injector(), injector()));
    injector.registerFactory<HomeTabBloc>(() => HomeTabBloc(injector(), injector(), injector(), injector()));
    injector.registerFactory<ProjectBloc>(() => ProjectBloc(injector(), injector(), injector(), injector(), injector()));
    injector.registerFactory<ScheduleTabBloc>(() => ScheduleTabBloc(injector(), injector(), injector(), injector(), injector()));
    injector.registerFactory<NotificationTabBloc>(() => NotificationTabBloc());
    injector.registerFactory<TaskBloc>(() => TaskBloc(injector(), injector(), injector(), injector(), injector(), injector()));
  }
}
