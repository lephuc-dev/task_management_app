class InvitationModel {
  String? id;
  String? projectId;
  String? userId;
  String? receiverId;
  String? role;
  DateTime? time;

  InvitationModel({
    this.id,
    this.projectId,
    this.userId,
    this.receiverId,
    this.role,
    this.time,
  });

  InvitationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    userId = json['user_id'];
    receiverId = json['receiver_id'];
    role = json['role'];
    if (json['time'] != null) {
      time = DateTime.fromMillisecondsSinceEpoch(json['time']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['project_id'] = projectId;
    data['user_id'] = userId;
    data['receiver_id'] = receiverId;
    data['role'] = role;
    if (time != null) {
      data['time'] = time!.millisecondsSinceEpoch;
    }
    return data;
  }
}
