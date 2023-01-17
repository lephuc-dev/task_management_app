import '../../base/base.dart';
import '../../repositories/repositories.dart';
import '../blocs.dart';

class SignUpBloc extends BaseBloc<SignUpState> {
  final AuthenticationRepository authenticationRepository;

  SignUpBloc(this.authenticationRepository);

  void onSignUp(String name, String email, String pass, Function onSuccess, Function(String) onError) {
    emitLoading(true);
    authenticationRepository
        .signUp(name, email, pass, onSuccess, onError)
        .catchError((error) => emit(SignUpState(state: state, error: error.toString())))
        .whenComplete(() => emitLoading(false));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
