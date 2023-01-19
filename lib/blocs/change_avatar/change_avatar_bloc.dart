import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'change_avatar.dart';

class ChangeAvatarBloc extends BaseBloc<ChangeAvatarState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  ChangeAvatarBloc(this.authenticationRepository, this.userRepository);

  Stream<User> getInformationUserStream() {
    return userRepository.getInformationUserByIdStream(authenticationRepository.getCurrentUserId());
  }

  Future<void> uploadImage(
    String? filePath,
    Function onUpdateSuccess,
    Function(String) onUpdateError,
  ) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    userRepository.changeAvatar(
      fileName,
      authenticationRepository.getCurrentUserId(),
      filePath ?? "",
      onUpdateSuccess,
      (error) => onUpdateError(error),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
