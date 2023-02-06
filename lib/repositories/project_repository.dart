import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class ProjectRepository {
  final _projectFirestore = FirebaseFirestore.instance.collection("PROJECTS");

  Stream<Project> getProjectStream(String projectId) {
    return _projectFirestore.where("id", isEqualTo: projectId).snapshots().map((snapshot) => Project.fromJson(snapshot.docs[0].data()));
  }

  void createProject({required String name}) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    _projectFirestore.doc(id).set({
      "id": id,
      "name": name,
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
}
