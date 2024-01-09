class UserModel {
  int u_id;
  String room;
  String email;
  String password;

  UserModel({
    required this.u_id,
    required this.room,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        u_id: json['u_id'],
        room: json['room'],
        email: json['email'],
        password: json['password']);
  }
}