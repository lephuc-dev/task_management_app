import '../../enum/ennum.dart';
import '../blocs.dart';
import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

class ProjectBloc extends BaseBloc<ProjectState> {
  final ProjectRepository projectRepository;
  final BoardRepository boardRepository;
  final TaskRepository taskRepository;
  final ProjectParticipantRepository projectParticipantRepository;
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;
  final InvitationRepository invitationRepository;
  final TaskParticipantRepository taskParticipantRepository;
  final NotificationRepository notificationRepository;

  ProjectBloc(
    this.projectRepository,
    this.boardRepository,
    this.projectParticipantRepository,
    this.taskRepository,
    this.userRepository,
    this.authenticationRepository,
    this.invitationRepository,
    this.taskParticipantRepository,
    this.notificationRepository,
  );

  Future<void> notification({required String projectId, required NotificationType type}) async {
    List<ProjectParticipant> list = await projectParticipantRepository.getListProjectParticipantByProjectId(projectId);

    if (list.isNotEmpty) {
      for (var element in list) {
        if (element.userId != authenticationRepository.getCurrentUserId() &&
            element.userId != "" &&
            authenticationRepository.getCurrentUserId() != "") {
          notificationRepository.createNotification(
            projectId: projectId,
            userId: authenticationRepository.getCurrentUserId(),
            receiverId: element.userId ?? "",
            taskId: "",
            type: type,
          );
        }
      }
    }
  }

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
    return projectParticipantRepository.getListProjectParticipantByProjectIdStream(projectId);
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

  void updateBoardName({required String id, required String name, required projectId}) {
    boardRepository.updateBoardName(id: id, name: name);
    notification(projectId: projectId, type: NotificationType.editBoardName);
  }

  void updateProjectName({required String projectId, required String name}) {
    projectRepository.updateName(projectId: projectId, name: name);
    notification(projectId: projectId, type: NotificationType.editProjectName);
  }

  void updateProjectDescription({required String projectId, required String description}) {
    projectRepository.updateDescription(projectId: projectId, description: description);
    notification(projectId: projectId, type: NotificationType.editProjectDescription);
  }

  void createBoard({required String projectId, required String name, required int index}) {
    boardRepository.createBoard(projectId: projectId, name: name, index: index);
  }

  Stream<String> getRole({required String projectId}) {
    return projectParticipantRepository.getRole(userId: authenticationRepository.getCurrentUserId(), projectId: projectId);
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
      return await projectParticipantRepository.checkInvalidNewUser(uid: uid, projectId: projectId);
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

  void deleteBoardAndListTask({required String boardId}) {
    boardRepository.deleteBoard(boardId: boardId);
    taskRepository.deleteListTask(boardId: boardId).then(
          (listTask) => {
            print("list task ::: ${listTask.length}"),
            for (var element in listTask)
              {
                print("task id ::: ${element.id}"),
                taskParticipantRepository.deleteListParticipant(taskId: element.id ?? ""),
              }
          },
        );
  }

  Stream<ProjectParticipant> getFavoriteStream({required String projectId}) {
    return projectParticipantRepository.getFavoriteStream(projectId: projectId, userId: authenticationRepository.getCurrentUserId());
  }

  void setFavoriteValue({required String id, required bool value}) {
    projectParticipantRepository.setFavoriteValue(id: id, value: value);
  }
}
