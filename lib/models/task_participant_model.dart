class TaskParticipant {
  String? id;
  String? userId;
  String? taskId;

  TaskParticipant({this.id, this.userId, this.taskId});

  TaskParticipant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskId = json['task_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['task_id'] = taskId;
    return data;
  }
}
