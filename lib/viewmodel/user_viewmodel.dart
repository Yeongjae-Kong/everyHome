import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

Future<List<UserModel>> fetchUsers() async {
  final response =
  await http.get(Uri.parse('http://3.144.38.43/user/fetchall'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> userList = jsonDecode(response.body);
    List<UserModel> users = [];
    for (final user in userList) {
      users.add(UserModel.fromJson(user));
    }
    return users;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Users');
  }
}

Future<UserModel?> fetchUserByEmail(String userEmail) async {
  List<UserModel> users = await fetchUsers();

  for (var user in users) {
    if (user.email == userEmail) return user;
  }
  return null;
}

Future<UserModel> addUser(UserModel user) async {
  final response = await http.post(
      Uri.parse('http://3.144.38.43/user/createuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'u_id': user.u_id,
        // 'name': user.name,
        // 'username': user.username,
        'room': user.room,
        'email': user.email,
        'password': user.password
      }));
  if (response.statusCode == 201) {
    print("해당 유저가 등록되었습니다.");
    return UserModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to add user');
  }
}

Future<UserModel?> fetchUserByUidWithoutGiven() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs에 대한 정보 날림
  // prefs.clear();
  //디버깅
  Set<String> allKeys = prefs.getKeys();
  print(allKeys);
  String uid = prefs.getString('u_id') ?? '0';
  List<UserModel> users = await fetchUsers();
  for (var user in users) {
    if (user.u_id == int.parse(uid)) return user;
  }
  return null;
}

Future<void> deleteUser(int u_id) async {
  try {
    final response = await http.delete(
      Uri.parse('http://3.144.38.43/user/deleteuser/$u_id'),
    );

    if (response.statusCode != 200 && response.statusCode != 203) { // 또는 다른 성공 상태 코드
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete user');
    }
  } catch (e) {
    print('Error in delete user: $e');
    throw e; // 예외를 다시 throw하여 상위에서 처리할 수 있게 함
  }
}