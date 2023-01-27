import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/models.dart';

class BoardRepository {
  final _boardFireStore = FirebaseFirestore.instance.collection("BOARDS");

  void createBoard(String projectId, String name, int index) {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    _boardFireStore
        .doc(id)
        .set({
          "id": id,
          "project_id": projectId,
          "name": name,
          "index": index,
        })
        .then((value) => debugPrint("completed"))
        .catchError((error) => debugPrint(error.toString()));
  }

  void updateBoardPosition(String id, int index) {
    _boardFireStore
        .doc(id)
        .update({
          "index": index,
        })
        .then((value) => debugPrint("completed ${index.toString()}"))
        .catchError((error) => debugPrint("fail"));
  }

  Stream<List<BoardModel>> getListBoardOrderByIndexStream(String projectId) {
    return _boardFireStore
        .where("project_id", isEqualTo: projectId)
        .orderBy("index", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => BoardModel.fromJson(document.data())).toList());
  }
}
