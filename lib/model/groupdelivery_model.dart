class GroupDeliveryModel {
  int id;
  String email;
  String title;
  String content;
  String image;
  int member;
  DateTime duetime;

  GroupDeliveryModel({
    required this.id,
    required this.email,
    required this.title,
    required this.content,
    required this.image,
    required this.member,
    required this.duetime
  });

  factory GroupDeliveryModel.fromJson(Map<String, dynamic> json) {
    return GroupDeliveryModel(
        id: json['id'],
        email: json['email'],
        title: json['title'],
        content: json['content'],
        image: json['image'],
        member: json['member'],
        duetime: DateTime.parse(json['duetime']));
  }
}