import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/models.dart';

class ProjectRepository {
  final _projectFirestore = FirebaseFirestore.instance.collection("PROJECTS");
  final _boardStorage = FirebaseStorage.instance.ref().child("PROJECTS");

  Stream<Project> getProjectStream(String projectId) {
    return _projectFirestore.where("id", isEqualTo: projectId).snapshots().map((snapshot) => Project.fromJson(snapshot.docs[0].data()));
  }

  Future<Project> getProject(String projectId) async {
    return await _projectFirestore.where("id", isEqualTo: projectId).snapshots().map((snapshot) => Project.fromJson(snapshot.docs[0].data())).first;
  }

  void createProject({required String id, required String name}) {
    _projectFirestore.doc(id).set({
      "id": id,
      "name": name,
      "description": "",
      "image": "",
    });
  }

  void updateName({required String projectId, required String name}) {
    _projectFirestore.doc(projectId).update({
      "name": name,
    });
  }

  void updateDescription({required String projectId, required String description}) {
    _projectFirestore.doc(projectId).update({
      "description": description,
    });
  }

  Future<void> changeImage({
    required String fileName,
    required String projectId,
    required String filePath,
  }) async {
    File file = File(filePath);
    Reference ref = _boardStorage.child(projectId).child("post_$fileName");
    await ref.putFile(file);
    String url = await ref.getDownloadURL();
    await _projectFirestore.doc(projectId).update({"image": url});
  }
}
