class LinkModel {
  String? title;
  String? url;

  LinkModel({
    this.title,
    this.url,
  });

  LinkModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}
