import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'change_name.dart';

class ChangeNameBloc extends BaseBloc<ChangeNameState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  ChangeNameBloc(this.authenticationRepository, this.userRepository);

  void onUpdateUser(String name, Function onSuccess, Function(String) onError) {
    emitLoading(true);
    userRepository.updateUser(name, authenticationRepository.getCurrentUserId(), onSuccess, onError).whenComplete(
          () => emitLoading(false),
        );
  }

  Stream<User> getInformationUserStream() {
    return userRepository.getInformationUserByIdStream(authenticationRepository.getCurrentUserId());
  }

  @override
  void dispose() {
    super.dispose();
  }
}
