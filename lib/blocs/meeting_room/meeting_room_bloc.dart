import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

import 'meeting_room.dart';


class MeetingRoomBloc extends BaseBloc<MeetingRoomState> {
  final MeetingRepository meetingRepository;
  final MeetingParticipantRepository meetingParticipantRepository;
  final AuthenticationRepository authenticationRepository;
  final ProjectParticipantRepository projectParticipantRepository;
  final ProjectRepository projectRepository;
  final UserRepository userRepository;

  MeetingRoomBloc(
      this.meetingRepository,
      this.meetingParticipantRepository,
      this.authenticationRepository,
      this.projectParticipantRepository,
      this.projectRepository,
      this.userRepository,
      );

  void createMeeting({required String name, required String projectId}) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    meetingRepository.createMeeting(name: name, id: id, projectId: projectId);
    // projectParticipantRepository.createProjectParticipant(projectId: id, userId: authenticationRepository.getCurrentUserId(), role: "Owner");
  }

  Stream<List<MeetingParticipantModel>> getListMeetingByMyIdStream() {
    return meetingParticipantRepository.getListMeetingParticipantByUidStream(authenticationRepository.getCurrentUserId());
  }

  Stream<List<ProjectParticipant>> getListProjectParticipantStream(String projectId) {
    return projectParticipantRepository.getListProjectParticipantByProjectIdStream(projectId);
  }

  Stream<Project> getProjectStream(String projectId) {
    return projectRepository.getProjectStream(projectId);
  }

  Stream<User> getUserStream(String userId){
    return userRepository.getInformationUserByIdStream(userId);
  }

  Stream<User> getCurrentUserStream(){
    return userRepository.getInformationUserByIdStream(authenticationRepository.getCurrentUserId());
  }

  Stream<List<MeetingModel>> getListMeetingByMyProjectIdStream(String projectId) {
    return meetingRepository.getMeetingByProjectIdStream(projectId);
  }
}
