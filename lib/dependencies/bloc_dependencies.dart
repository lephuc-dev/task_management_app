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
  }
}
