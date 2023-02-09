class MeetingParticipantModel {
  String? id;
  String? meetingId;
  String? userId;
  String? role;

  MeetingParticipantModel({
    this.id,
    this.meetingId,
    this.userId,
    this.role
  });

  MeetingParticipantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingId = json['meeting_id'];
    userId = json['user_id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['meeting_id'] = meetingId;
    data['user_id'] = userId;
    data['role'] = role;
    return data;
  }
}