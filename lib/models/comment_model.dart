class CommentModel {
  String? id;
  String? userId;
  String? taskId;
  String? content;
  String? date;

  CommentModel({
    this.id,
    this.userId,
    this.taskId,
    this.content,
    this.date,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskId = json['task_id'];
    content = json['content'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['task_id'] = taskId;
    data['content'] = content;
    data['date'] = date;
    return data;
  }
}
