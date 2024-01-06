class UserModel {
  int u_id;
  // String username;
  // String name;
  String room;
  String email;
  String password;

  UserModel({
    required this.u_id,
    // required this.username,
    // required this.name,
    required this.room,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        u_id: json['u_id'],
        // username: json['username'],
        // name: json['name'],
        room: json['room'],
        email: json['email'],
        password: json['password']);
  }
}