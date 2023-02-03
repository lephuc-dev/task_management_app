class CheckListItemModel {
  String? content;
  bool? isDone;

  CheckListItemModel({
    this.content,
    this.isDone,
  });

  CheckListItemModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['isDone'] = isDone;
    return data;
  }
}
