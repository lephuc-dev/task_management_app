import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'meeting.dart';

class MeetingBloc extends BaseBloc<MeetingState> {
  final MeetingRepository meetingRepository;
  final MeetingParticipantRepository meetingParticipantRepository;
  final AuthenticationRepository authenticationRepository;
  final ProjectParticipantRepository projectParticipantRepository;
  final ProjectRepository projectRepository;

  MeetingBloc(
      this.meetingRepository,
      this.meetingParticipantRepository,
      this.authenticationRepository,
      this.projectParticipantRepository,
      this.projectRepository,
  );

  void createMeeting({required String name, required String projectId}) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    meetingRepository.createMeeting(name: name, id: id, projectId: projectId);
   // projectParticipantRepository.createProjectParticipant(projectId: id, userId: authenticationRepository.getCurrentUserId(), role: "Owner");
  }

  Stream<List<MeetingParticipantModel>> getListMeetingByMyIdStream() {
    return meetingParticipantRepository.getListMeetingParticipantByUidStream(authenticationRepository.getCurrentUserId());
  }

  Stream<List<ProjectParticipant>> getListOwnProjectByMyIdStream() {
    return projectParticipantRepository.getListOwnProjectParticipantByUidStream(authenticationRepository.getCurrentUserId());
  }

  Stream<List<ProjectParticipant>> getListProjectByMyIdStream() {
    return projectParticipantRepository.getListProjectParticipantByUidStream(authenticationRepository.getCurrentUserId());
  }

  Stream<Project> getProjectStream(String projectId) {
    return projectRepository.getProjectStream(projectId);
  }

  Stream<List<MeetingModel>> getListMeetingByMyProjectIdStream(String projectId) {
    return meetingRepository.getMeetingByProjectIdStream(projectId);
  }
}
