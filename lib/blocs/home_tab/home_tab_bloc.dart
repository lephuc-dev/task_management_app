import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../blocs.dart';

class HomeTabBloc extends BaseBloc<HomeTabState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final ProjectRepository projectRepository;
  final ProjectParticipantRepository projectParticipantRepository;

  HomeTabBloc(this.authenticationRepository, this.userRepository, this.projectRepository, this.projectParticipantRepository);

  Stream<User> getInformationUserStream() {
    return userRepository.getInformationUserByIdStream(authenticationRepository.getCurrentUserId());
  }

  Stream<User> getInformationUserByIdStream(String uid) {
    return userRepository.getInformationUserByIdStream(uid);
  }

  Stream<List<ProjectParticipant>> getListProjectByMyIdStream() {
    return projectParticipantRepository.getListProjectParticipantByUidStream(authenticationRepository.getCurrentUserId());
  }

  Stream<List<ProjectParticipant>> getListFavoriteProjectByMyIdStream() {
    return projectParticipantRepository.getListFavoriteProjectParticipantByUidStream(authenticationRepository.getCurrentUserId());
  }

  Stream<Project> getProjectStream(String projectId) {
    return projectRepository.getProjectStream(projectId);
  }

  void createProject({required String name}) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    projectRepository.createProject(name: name, id: id);
    projectParticipantRepository.createProjectParticipant(projectId: id, userId: authenticationRepository.getCurrentUserId(), role: "Owner");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
