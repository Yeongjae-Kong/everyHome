class GroupBuyingModel {
  int id;
  String email;
  String title;
  String content;
  String image;
  int member;

  GroupBuyingModel({
    required this.id,
    required this.email,
    required this.title,
    required this.content,
    required this.image,
    required this.member,
  });

  factory GroupBuyingModel.fromJson(Map<String, dynamic> json) {
    return GroupBuyingModel(
        id: json['id'],
        email: json['email'],
        title: json['title'],
        content: json['content'],
        image: json['image'],
        member: json['member']);
  }
}