import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class ProjectParticipantRepository {
  final _projectParticipantFirestore = FirebaseFirestore.instance.collection("PROJECT_PARTICIPANT");

  Stream<List<ProjectParticipant>> getListProjectParticipantByUidStream(String userId) {
    return _projectParticipantFirestore
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => ProjectParticipant.fromJson(document.data())).toList());
  }

  Stream<List<ProjectParticipant>> getListFavoriteProjectParticipantByUidStream(String userId) {
    return _projectParticipantFirestore
        .where("user_id", isEqualTo: userId)
        .where("favorite", isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => ProjectParticipant.fromJson(document.data())).toList());
  }

  Stream<List<ProjectParticipant>> getListProjectParticipantByProjectIdStream(String projectId) {
    return _projectParticipantFirestore
        .where("project_id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => ProjectParticipant.fromJson(document.data())).toList());
  }

  Stream<String> getRole({required String userId, required String projectId}) {
    return _projectParticipantFirestore
        .where("user_id", isEqualTo: userId)
        .where("project_id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot) => snapshot.docs[0]['role']);
  }

  void createProjectParticipant({required String projectId, required String userId, required String role}) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    _projectParticipantFirestore.doc(id).set({
      "id": id,
      "project_id": projectId,
      "user_id": userId,
      "role": role,
      "favorite": false,
    });
  }

  Future<bool> checkInvalidNewUser({required String uid, required String projectId}) async {
    List<ProjectParticipant> list = await _projectParticipantFirestore
        .where("project_id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => ProjectParticipant.fromJson(document.data())).toList())
        .first;

    for (var element in list) {
      if (element.userId == uid || uid == "") {
        return false;
      }
    }
    return true;
  }

  void deleteProjectParticipant({required String id}) {
    _projectParticipantFirestore.doc(id).delete();
  }

  Stream<ProjectParticipant> getFavoriteStream({required String projectId, required String userId}) {
    return _projectParticipantFirestore
        .where("project_id", isEqualTo: projectId)
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .map((snapshot) => ProjectParticipant.fromJson(snapshot.docs[0].data()));
  }

  void setFavoriteValue({required String id, required bool value}) {
    _projectParticipantFirestore.doc(id).update({
      "favorite": value,
    });
  }
}
