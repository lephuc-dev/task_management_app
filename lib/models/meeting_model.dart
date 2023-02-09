class MeetingModel {
  String? id;
  String? projectId;
  String? name;

  MeetingModel({
    this.id,
    this.projectId,
    this.name,
  });

  MeetingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['project_id'] = projectId;
    data['name'] = name;
    return data;
  }
}