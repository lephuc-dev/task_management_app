import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../blocs.dart';

class NotificationTabBloc extends BaseBloc<NotificationTabState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final ProjectRepository projectRepository;
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

  @override
  void dispose() {
    super.dispose();
  }
}
