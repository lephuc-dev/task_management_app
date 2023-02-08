import '../blocs.dart';
import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

class ProjectBloc extends BaseBloc<ProjectState> {
  final ProjectRepository projectRepository;
  final BoardRepository boardRepository;
  final TaskRepository taskRepository;
  final ProjectParticipantRepository participantRepository;
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;
  final InvitationRepository invitationRepository;

  ProjectBloc(
    this.projectRepository,
    this.boardRepository,
    this.participantRepository,
    this.taskRepository,
    this.userRepository,
    this.authenticationRepository,
    this.invitationRepository,
  );

  Stream<List<BoardModel>> getListBoardOrderByIndexStream(String projectId) {
    return boardRepository.getListBoardOrderByIndexStream(projectId);
  }

  Stream<List<TaskModel>> getListTaskOrderByIndexStream(String boardId) {
    return taskRepository.getListTaskOrderByIndexStream(boardId);
  }

  void updateBoardPosition(String id, int index) {
    boardRepository.updateBoardPosition(id, index);
  }

  Stream<Project> getProjectStream(String projectId) {
    return projectRepository.getProjectStream(projectId);
  }

  Stream<List<ProjectParticipant>> getListProjectParticipantByProjectIdStream(String projectId) {
    return participantRepository.getListProjectParticipantByProjectIdStream(projectId);
  }

  Stream<List<InvitationModel>> getListInvitationByProjectId(String projectId) {
    return invitationRepository.getListInvitationByProjectId(projectId);
  }

  Stream<User> getInformationUserByIdStream(String uid) {
    return userRepository.getInformationUserByIdStream(uid);
  }

  void createTask({required String name, required String boardId, required String projectId, required int index}) {
    taskRepository.createTask(name: name, boardId: boardId, projectId: projectId, index: index);
  }

  void updateBoardName({required String id, required String name}) {
    boardRepository.updateBoardName(id: id, name: name);
  }

  void updateProjectName({required String projectId, required String name}) {
    projectRepository.updateName(projectId: projectId, name: name);
  }

  void updateProjectDescription({required String projectId, required String description}) {
    projectRepository.updateDescription(projectId: projectId, description: description);
  }

  void createBoard({required String projectId, required String name, required int index}) {
    boardRepository.createBoard(projectId: projectId, name: name, index: index);
  }

  Stream<String> getRole({required String projectId}) {
    return participantRepository.getRole(userId: authenticationRepository.getCurrentUserId(), projectId: projectId);
  }

  Future<void> changeImage({required String filePath, required String projectId}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    projectRepository.changeImage(
      fileName: fileName,
      projectId: projectId,
      filePath: filePath,
    );
  }

  Future<String?> getUidByEmail({required String email}) async {
    String? result = await userRepository.getUidByEmail(email);
    return result;
  }

  Future<bool> checkInvalidNewUser({required String projectId, required String email}) async {
    String? uid = await userRepository.getUidByEmail(email);
    if (uid != null) {
      return await participantRepository.checkInvalidNewUser(uid: uid, projectId: projectId);
    }
    return false;
  }

  Future<bool> checkInvalidInvitation({required String projectId, required String email}) async {
    String? uid = await userRepository.getUidByEmail(email);
    if (uid != null) {
      return await invitationRepository.check(userId: uid, projectId: projectId);
    }
    return false;
  }

  Future<void> createInvitation({required String projectId, required String role, required String receiverId}) async {
    invitationRepository.createInvitation(
      projectId: projectId,
      userId: authenticationRepository.getCurrentUserId(),
      receiverId: receiverId,
      role: role,
    );
  }

  void deleteInvitation({required String id}) {
    invitationRepository.deleteInvitation(id);
  }
}
