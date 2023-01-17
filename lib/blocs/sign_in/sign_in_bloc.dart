import '../../base/base.dart';
import '../../repositories/repositories.dart';
import '../blocs.dart';

class SignInBloc extends BaseBloc<SignInState> {
  final AuthenticationRepository authenticationRepository;

  SignInBloc(this.authenticationRepository);

  void onSignIn(String email, String pass, Function onSuccess, Function(String) onError) {
    emitLoading(true);
    authenticationRepository
        .signIn(email, pass, onSuccess, onError)
        .catchError((error) => emit(SignInState(state: state, error: error.toString())))
        .whenComplete(() => emitLoading(false));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
