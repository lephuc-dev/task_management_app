import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class TaskRepository {
  final _taskFireStore = FirebaseFirestore.instance.collection("TASKS");

  Stream<List<TaskModel>> getListTaskOrderByIndexStream(String projectId) {
    return _taskFireStore
        .where("board_id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => TaskModel.fromJson(document.data())).toList());
  }

  Stream<TaskModel> getTaskStream(String taskId) {
    return _taskFireStore.where("id", isEqualTo: taskId).snapshots().map((snapshot) => TaskModel.fromJson(snapshot.docs[0].data()));
  }

  // Stream<QuerySnapshot<dynamic>> getListTaskCardByProjectidStream(
  //     String project_id) {
  //   return _taskFireStore
  //       .where("project_id", isEqualTo: project_id)
  //       .snapshots();
  // }
  //
  // Future<void> AddNewTaskState(List_Object list, String title, String decription, DateTimeRange time) {
  //   String id = (new DateTime.now().microsecondsSinceEpoch).toString();
  //   return _taskFireStore
  //       .doc(id)
  //       .set({
  //     "id" : id,
  //     "list_id" : list.id,
  //     "project_id" : list.projecId,
  //     "title" : title,
  //     "decription" : decription,
  //     "start_date" : time.start.microsecondsSinceEpoch.toString(),
  //     "end_date" : time.end.microsecondsSinceEpoch.toString(),
  //   })
  //       .then((value) => print("completed add task"))
  //       .catchError((error) => print("fail"));
  // }
  //
  // Future<void> UpdateTaskState(String id, String list_id) {
  //   return _taskFireStore
  //       .doc(id)
  //       .update({
  //         "list_id": list_id,
  //       })
  //       .then((value) => print("completed"))
  //       .catchError((error) => print("fail"));
  // }
}
