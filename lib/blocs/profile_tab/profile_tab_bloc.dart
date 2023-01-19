import '../../base/base.dart';
import '../blocs.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

class ProfileTabBloc extends BaseBloc<ProfileTabState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  ProfileTabBloc(this.authenticationRepository, this.userRepository);

  Stream<User?> getInformationUserStream() {
    return userRepository.getInformationUserByIdStream(authenticationRepository.getCurrentUserId());
  }

  @override
  void dispose() {
    super.dispose();
  }
}
