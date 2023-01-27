class TaskModel {
  String? id;
  String? projectId;
  String? boardId;
  int? index;
  String? name;

  TaskModel({
    this.id,
    this.boardId,
    this.index,
    this.name,
    this.projectId,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    boardId = json['board_id'];
    projectId = json['project_id'];
    index = json['index'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['board_id'] = boardId;
    data['project_id'] = projectId;
    data['index'] = index;
    data['name'] = name;
    return data;
  }
}
