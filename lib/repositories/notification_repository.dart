import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/models.dart';

class NotificationRepository {
  final _notificationFireStore = FirebaseFirestore.instance.collection("NOTIFICATIONS");

  void createNotification({
    required String projectId,
    required String userId,
    required String receiverId,
    required String taskId,
    required String content,
  }) {
    int id = DateTime.now().microsecondsSinceEpoch;
    _notificationFireStore
        .doc(id.toString())
        .set({
          "id": id.toString(),
          "project_id": projectId,
          "user_id": userId,
          "receiver_id": receiverId,
          "task_id": taskId,
          "content": content,
          "time": id,
        })
        .then((value) => debugPrint("completed"))
        .catchError((error) => debugPrint(error.toString()));
  }

  void setIsReadTrue({required String notificationId}) {
    _notificationFireStore.doc(notificationId).update({
      "is_read": true,
    });
  }

  void deleteNotification(String id) {
    _notificationFireStore.doc(id).delete();
  }

  Stream<List<NotificationModel>> getListNotificationByUid(String uid) {
    return _notificationFireStore
        .where("receiver_id", isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => NotificationModel.fromJson(document.data())).toList());
  }
}
