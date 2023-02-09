import 'package:task_management_app/enum/ennum.dart';

class NotificationModel {
  String? id;
  String? projectId;
  String? taskId;
  String? userId;
  String? receiverId;
  NotificationType? type;
  DateTime? time;
  bool? isRead;

  NotificationModel({
    this.id,
    this.projectId,
    this.taskId,
    this.userId,
    this.receiverId,
    this.type,
    this.time,
    this.isRead,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    taskId = json['task_id'];
    userId = json['user_id'];
    receiverId = json['receiver_id'];
    type = NotificationType.values.byName(json['type']);
    isRead = json['is_read'];
    if (json['time'] != null) {
      time = DateTime.fromMillisecondsSinceEpoch(json['time']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['project_id'] = projectId;
    data['task_id'] = taskId;
    data['user_id'] = userId;
    data['receiver_id'] = receiverId;
    data['type'] = type?.name;
    data['is_read'] = isRead;
    if (time != null) {
      data['time'] = time!.millisecondsSinceEpoch;
    }
    return data;
  }
}
