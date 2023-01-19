import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../blocs.dart';

class ChangePasswordBloc extends BaseBloc<ChangePasswordState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  ChangePasswordBloc(this.authenticationRepository, this.userRepository);

  Stream<User> getInformationUserStream() {
    return userRepository.getInformationUserByIdStream(authenticationRepository.getCurrentUserId());
  }

  void onUpdatePassword(String newPassword, Function onSuccess, Function(String) onError) {
    authenticationRepository.updatePassword(newPassword, onSuccess, onError);
  }

  void onSignIn(String email, String pass, Function onSuccess, Function(String) onError) {
    authenticationRepository.signIn(email, pass, onSuccess, onError);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
