class BoardModel {
  String? id;
  int? index;
  String? projectId;
  String? name;

  BoardModel({
    this.id,
    this.index,
    this.projectId,
    this.name,
  });

  BoardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    index = json['index'];
    name = json['name'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['index'] = index;
    data['project_id'] = projectId;
    data['name'] = name;
    return data;
  }
}
