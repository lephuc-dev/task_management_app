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

  TaskModel({
    this.id,
    this.boardId,
    this.index,
    this.name,
    this.projectId,
    this.description,
    this.links,
    this.checklist,
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
    return data;
  }
}
