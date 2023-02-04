import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/models.dart';

class CommentRepository {
  final _commentFireStore = FirebaseFirestore.instance.collection("COMMENTS");

  void createComment(String userId, String taskId, String content) {
    DateTime dateTime = DateTime.now();
    String id = dateTime.microsecondsSinceEpoch.toString();
    _commentFireStore
        .doc(id)
        .set({
          "id": id,
          "user_id": userId,
          "task_id": taskId,
          "content": content,
          "date":
              "${dateTime.day.toString().padLeft(2, "0")}/${dateTime.month.toString().padLeft(2, "0")}/${dateTime.year} - ${dateTime.hour.toString().padLeft(2, "0")}:${dateTime.minute.toString().padLeft(2, "0")}",
        })
        .then((value) => debugPrint("completed"))
        .catchError((error) => debugPrint(error.toString()));
  }

  Stream<List<CommentModel>> getListCommentByTaskId(String taskId) {
    return _commentFireStore
        .where("task_id", isEqualTo: taskId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => CommentModel.fromJson(document.data())).toList());
  }
  void deleteComment({required String commentId}) {
    _commentFireStore.doc(commentId).delete();
  }
}
