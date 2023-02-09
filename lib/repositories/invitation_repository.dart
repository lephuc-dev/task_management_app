import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/models.dart';

class InvitationRepository {
  final _invitationFireStore = FirebaseFirestore.instance.collection("INVITATIONS");

  void createInvitation({required String projectId, required String userId, required String role, required String receiverId}) {
    int id = DateTime.now().microsecondsSinceEpoch;
    _invitationFireStore
        .doc(id.toString())
        .set({
          "id": id.toString(),
          "project_id": projectId,
          "user_id": userId,
          "receiver_id": receiverId,
          "role": role,
          "time": id,
        })
        .then((value) => debugPrint("completed"))
        .catchError((error) => debugPrint(error.toString()));
  }

  void deleteInvitation(String id) {
    _invitationFireStore.doc(id).delete();
  }

  Future<bool> check({required String projectId, required String userId}) async {
    if (userId == "") {
      return false;
    }
    List<InvitationModel> list = await _invitationFireStore
        .where("project_id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => InvitationModel.fromJson(document.data())).toList())
        .first;

    for (var element in list) {
      if (element.receiverId == userId) {
        return false;
      }
    }

    return true;
  }

  Stream<List<InvitationModel>> getListInvitationByProjectId(String projectId) {
    return _invitationFireStore
        .where("project_id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => InvitationModel.fromJson(document.data())).toList());
  }

  Stream<List<InvitationModel>> getListInvitationByReceiverId(String receiverId) {
    return _invitationFireStore
        .where("receiver_id", isEqualTo: receiverId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => InvitationModel.fromJson(document.data())).toList());
  }
}
