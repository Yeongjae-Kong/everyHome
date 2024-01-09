class BoardModel{
  int id;
  String email;
  String title;
  String content;
  String image;

  BoardModel({
    required this.id,
    required this.email,
    required this.title,
    required this.content,
    required this.image

});
  factory BoardModel.fromJson(Map<String, dynamic> json){
    return BoardModel(
        id: json['id'],
        email: json['email'],
        title: json['title'],
        content: json['content'],
        image: json['image']);
  }
  }
