import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class MeetingParticipantRepository {
  final _meetingPaticipantFireStore = FirebaseFirestore.instance.collection("MEETING_PARTICIPANT");

  Stream<List<MeetingParticipantModel>> getListMeetingParticipantByUidStream(String userId) {
    return _meetingPaticipantFireStore
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => MeetingParticipantModel.fromJson(document.data())).toList());
  }

  // Stream<List<ProjectParticipant>> getListProjectParticipantByProjectIdStream(String projectId) {
  //   return _meetingPaticipantFireStore
  //       .where("project_id", isEqualTo: projectId)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((document) => ProjectParticipant.fromJson(document.data())).toList());
  // }
  //
  // Stream<String> getRole({required String userId, required String projectId}) {
  //   return _meetingPaticipantFireStore
  //       .where("user_id", isEqualTo: userId)
  //       .where("project_id", isEqualTo: projectId)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs[0]['role']);
  // }
  //
  // void createProjectParticipant({required String projectId, required String userId, required String role}) {
  //   String id = DateTime.now().millisecondsSinceEpoch.toString();
  //   _meetingPaticipantFireStore.doc(id).set({
  //     "id": id,
  //     "project_id": projectId,
  //     "user_id": userId,
  //     "role": role,
  //     "favorite": false,
  //   });
  // }

}
