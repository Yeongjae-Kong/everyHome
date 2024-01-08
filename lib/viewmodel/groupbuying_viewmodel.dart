import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/groupbuying_model.dart';

Future<List<GroupBuyingModel>> fetchGroupBuyings() async {
  final response = await http.get(Uri.parse('http://3.144.38.43/groupbuying/fetchall'));

  if (response.statusCode == 200) {
    List<dynamic> groupBuyingList = jsonDecode(response.body);
    return groupBuyingList.map((data) => GroupBuyingModel.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load group buyings');
  }
}

Future<GroupBuyingModel?> addGroupBuying(GroupBuyingModel groupBuying) async {
  print('Sending request with:');
  print('Email: ${groupBuying.email}');
  print('Title: ${groupBuying.title}');
  print('Content: ${groupBuying.content}');
  print('Image: ${groupBuying.image}');
  print('Member: ${groupBuying.member}');

  final response = await http.post(
    Uri.parse('http://3.144.38.43/groupbuying/creategroupbuying'), // 서버 엔드포인트
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': groupBuying.email,
      'title': groupBuying.title,
      'content': groupBuying.content,
      'image': groupBuying.image,
      'member': groupBuying.member,
    }),
  );

  if (response.statusCode == 201) {
    // 성공적으로 데이터가 추가되었을 때의 처리
    print('Group buying added successfully');
  } else {
    // 서버 응답 에러 처리
    print('Failed to add group buying. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to add group buying');
  }
}

Future<void> deleteGroupBuying(int id) async {
  try {
    final response = await http.delete(
      Uri.parse('http://3.144.38.43/groupbuying/deletegroupbuying/$id'),
    );

    if (response.statusCode != 200 && response.statusCode != 203) { // 또는 다른 성공 상태 코드
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete group buying');
    }
  } catch (e) {
    print('Error in deleteGroupBuying: $e');
    throw e; // 예외를 다시 throw하여 상위에서 처리할 수 있게 함
  }
}