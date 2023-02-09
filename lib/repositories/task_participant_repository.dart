import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class TaskParticipantRepository {
  final _taskParticipantFirestore = FirebaseFirestore.instance.collection("TASK_PARTICIPANT");

  Stream<List<TaskParticipant>> getListTaskParticipantByUidStream(String userId) {
    return _taskParticipantFirestore
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => TaskParticipant.fromJson(document.data())).toList());
  }

  Stream<List<TaskParticipant>> getListTaskParticipantByTaskIdStream(String taskId) {
    return _taskParticipantFirestore
        .where("task_id", isEqualTo: taskId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => TaskParticipant.fromJson(document.data())).toList());
  }

  void createTaskParticipant({required String userId, required String taskId}) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    _taskParticipantFirestore.doc(id).set({
      "id": id,
      "user_id": userId,
      "task_id": taskId,
    });
  }

  void deleteTaskParticipant({required String participantId}) {
    _taskParticipantFirestore.doc(participantId).delete();
  }

  Future<void> deleteListParticipant({required String taskId}) async {
    List<TaskParticipant> list = await _taskParticipantFirestore
        .where("task_id", isEqualTo: taskId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => TaskParticipant.fromJson(document.data())).toList())
        .first;

    for (var element in list) {
      deleteTaskParticipant(participantId: element.id ?? "");
    }

    print("delete completed list task participant");
  }
}
