import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class MeetingRepository {
  final _meetingFireStore = FirebaseFirestore.instance.collection("MEETINGS");

  void createMeeting({required String id, required String name, required String projectId}) {
    print(projectId);
    _meetingFireStore.doc(id).set({
      "id": id,
      "project_id": projectId,
      "name": name,
    });
  }

  Stream<List<MeetingModel>> getMeetingByProjectIdStream(String projectId) {
    return _meetingFireStore.where("project_id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot)  => snapshot.docs.map((document) => MeetingModel.fromJson(document.data())).toList());
  }

  void updateName({required String taskId,required String newName}) {
    _meetingFireStore.doc(taskId).update({
      "name": newName,
    });
  }

}
