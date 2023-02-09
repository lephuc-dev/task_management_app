import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class TaskRepository {
  final _taskFireStore = FirebaseFirestore.instance.collection("TASKS");

  void createTask({required String name, required String boardId, required String projectId, required int index}) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    _taskFireStore.doc(id).set({
      "id": id,
      "project_id": projectId,
      "board_id": boardId,
      "name": name,
      "completed": false,
    });
  }

  Stream<List<TaskModel>> getListTaskOrderByIndexStream(String projectId) {
    return _taskFireStore
        .where("board_id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => TaskModel.fromJson(document.data())).toList());
  }

  Stream<TaskModel> getTaskStream(String taskId) {
    return _taskFireStore.where("id", isEqualTo: taskId).snapshots().map((snapshot) => TaskModel.fromJson(snapshot.docs[0].data()));
  }

  void updateName(String taskId, String newName) {
    _taskFireStore.doc(taskId).update({
      "name": newName,
    });
  }

  void updateDescription(String taskId, String newDescription) {
    _taskFireStore.doc(taskId).update({
      "description": newDescription,
    });
  }

  void setDoneTaskState({
    required String taskId,
    required List<CheckListItemModel>? checklist,
    required int index,
    required bool isDone,
  }) {
    List<CheckListItemModel>? listTemp = [];
    for (int i = 0; i < (checklist?.length ?? 0); i++) {
      if (i != index) {
        listTemp.add(checklist?[i] ?? CheckListItemModel());
      } else {
        listTemp.add(CheckListItemModel(content: checklist?[i].content, isDone: isDone));
      }
    }
    if (listTemp.isNotEmpty) {
      _taskFireStore.doc(taskId).update({
        "checklist": listTemp.map((v) => v.toJson()).toList(),
      });
    }
  }

  void updateCompletedState({required String taskId, required bool value}) {
    _taskFireStore.doc(taskId).update({
      "completed": value,
    });
  }

  void updateCheckListItemContent({
    required String taskId,
    required List<CheckListItemModel>? checklist,
    required int index,
    required String content,
  }) {
    List<CheckListItemModel>? listTemp = [];
    for (int i = 0; i < (checklist?.length ?? 0); i++) {
      if (i != index) {
        listTemp.add(checklist?[i] ?? CheckListItemModel());
      } else {
        listTemp.add(CheckListItemModel(content: content, isDone: checklist?[i].isDone));
      }
    }
    if (listTemp.isNotEmpty) {
      _taskFireStore.doc(taskId).update({
        "checklist": listTemp.map((v) => v.toJson()).toList(),
      });
    }
  }

  void deleteCheckListItem({
    required String taskId,
    required List<CheckListItemModel>? checklist,
    required int index,
  }) {
    List<CheckListItemModel>? listTemp = [];
    for (int i = 0; i < (checklist?.length ?? 0); i++) {
      if (i != index) {
        listTemp.add(checklist?[i] ?? CheckListItemModel());
      }
    }
    _taskFireStore.doc(taskId).update({
      "checklist": listTemp.map((v) => v.toJson()).toList(),
    });
  }

  void addCheckListItem({
    required String taskId,
    required List<CheckListItemModel>? checklist,
  }) {
    checklist ??= [];
    checklist.add(CheckListItemModel(content: "Todo ${checklist.length + 1}", isDone: false));
    _taskFireStore.doc(taskId).update({
      "checklist": checklist.map((v) => v.toJson()).toList(),
    });
  }

  void deleteLinkListItem({
    required String taskId,
    required List<LinkModel>? list,
    required int index,
  }) {
    List<LinkModel>? listTemp = [];
    for (int i = 0; i < (list?.length ?? 0); i++) {
      if (i != index) {
        listTemp.add(list?[i] ?? LinkModel());
      }
    }
    _taskFireStore.doc(taskId).update({
      "links": listTemp.map((v) => v.toJson()).toList(),
    });
  }

  void addLinkListItem({
    required String taskId,
    required List<LinkModel>? list,
    required String title,
    required String url,
  }) {
    list ??= [];
    list.add(LinkModel(title: title, url: url));
    _taskFireStore.doc(taskId).update({
      "links": list.map((v) => v.toJson()).toList(),
    });
  }

  void updateLinkListItem({
    required String taskId,
    required List<LinkModel>? list,
    required int index,
    required String title,
    required String url,
  }) {
    List<LinkModel>? listTemp = [];
    for (int i = 0; i < (list?.length ?? 0); i++) {
      if (i != index) {
        listTemp.add(list?[i] ?? LinkModel());
      } else {
        listTemp.add(LinkModel(title: title, url: url));
      }
    }
    if (listTemp.isNotEmpty) {
      _taskFireStore.doc(taskId).update({
        "links": listTemp.map((v) => v.toJson()).toList(),
      });
    }
  }

  void updateFromAndToTime({required String taskId, required DateTime from, required DateTime to}) {
    int fromTime = from.millisecondsSinceEpoch;
    int toTime = to.millisecondsSinceEpoch;
    _taskFireStore.doc(taskId).update({
      "from": fromTime,
      "to": toTime,
    });
  }

  void deleteTask({required String taskId}) {
    _taskFireStore.doc(taskId).delete();
  }
}
