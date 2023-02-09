import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../blocs.dart';

class NotificationTabBloc extends BaseBloc<NotificationTabState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final ProjectRepository projectRepository;
  final TaskRepository taskRepository;
  final InvitationRepository invitationRepository;
  final ProjectParticipantRepository projectParticipantRepository;
  final NotificationRepository notificationRepository;

  NotificationTabBloc(
    this.authenticationRepository,
    this.userRepository,
    this.projectRepository,
    this.invitationRepository,
    this.projectParticipantRepository,
    this.notificationRepository,
    this.taskRepository,
  );

  Stream<List<InvitationModel>> getListInvitationByMyId() {
    return invitationRepository.getListInvitationByReceiverId(authenticationRepository.getCurrentUserId());
  }

  Stream<User> getInformationUserByIdStream(String uid) {
    return userRepository.getInformationUserByIdStream(uid);
  }

  Stream<Project> getProjectStream(String projectId) {
    return projectRepository.getProjectStream(projectId);
  }

  void rejectInvitation({required String invitationId}) {
    invitationRepository.deleteInvitation(invitationId);
  }

  void acceptInvitation({required InvitationModel? invitationModel}) {
    invitationRepository.deleteInvitation(invitationModel?.id ?? "");
    projectParticipantRepository.createProjectParticipant(
      projectId: invitationModel?.projectId ?? "",
      userId: invitationModel?.receiverId ?? "",
      role: invitationModel?.role ?? "",
    );
  }

  Stream<List<NotificationModel>> getListNotificationByMyId() {
    return notificationRepository.getListNotificationByUid(authenticationRepository.getCurrentUserId());
  }

  void setIsRead({required String notificationId}) {
    notificationRepository.setIsReadTrue(notificationId: notificationId);
  }

  void deleteNotification({required String notificationId}) {
    notificationRepository.deleteNotification(notificationId);
  }

  Future<TaskModel> getTask(String taskId) async {
    return await taskRepository.getTask(taskId);
  }

  Future<Project> getProject(String projectId) async {
    return await projectRepository.getProject(projectId);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
