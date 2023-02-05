import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

class TaskModel {
  String? id;
  String? projectId;
  String? boardId;
  int? index;
  String? name;
  String? description;
  List<LinkModel>? links;
  List<CheckListItemModel>? checklist;
  DateTime? from;
  DateTime? to;
  bool? completed;

  TaskModel({
    this.id,
    this.boardId,
    this.index,
    this.name,
    this.projectId,
    this.description,
    this.links,
    this.checklist,
    this.from,
    this.to,
    this.completed,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    boardId = json['board_id'];
    projectId = json['project_id'];
    index = json['index'];
    name = json['name'];
    description = json['description'];
    if (json['links'] != null && json['links'].isNotEmpty) {
      links = <LinkModel>[];
      json['links'].forEach((v) {
        links!.add(LinkModel.fromJson(v));
      });
    }
    if (json['checklist'] != null && json['checklist'].isNotEmpty) {
      checklist = <CheckListItemModel>[];
      json['checklist'].forEach((v) {
        checklist!.add(CheckListItemModel.fromJson(v));
      });
    }
    if (json['from'] != null) {
      from = DateTime.fromMillisecondsSinceEpoch(json['from']);
    }
    if (json['to'] != null) {
      to = DateTime.fromMillisecondsSinceEpoch(json['to']);
    }
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['board_id'] = boardId;
    data['project_id'] = projectId;
    data['index'] = index;
    data['name'] = name;
    data['description'] = description;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    if (checklist != null) {
      data['checklist'] = checklist!.map((v) => v.toJson()).toList();
    }
    if (from != null) {
      data['from'] = from!.millisecondsSinceEpoch;
    }
    if (to != null) {
      data['to'] = to!.millisecondsSinceEpoch;
    }
    data['completed'] = completed;
    return data;
  }
}
