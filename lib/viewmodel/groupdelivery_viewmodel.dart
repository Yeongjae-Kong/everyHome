import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Groupdelivery_model.dart';

Future<List<GroupDeliveryModel>> fetchGroupDeliverys() async {
  final response = await http.get(Uri.parse('http://3.144.38.43/GroupDelivery/fetchall'));

  if (response.statusCode == 200) {
    List<dynamic> GroupDeliveryList = jsonDecode(response.body);
    return GroupDeliveryList.map((data) => GroupDeliveryModel.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load group buyings');
  }
}

Future<GroupDeliveryModel?> addGroupDelivery(GroupDeliveryModel GroupDelivery) async {
  print('Sending request with:');
  print('Email: ${GroupDelivery.email}');
  print('Title: ${GroupDelivery.title}');
  print('Content: ${GroupDelivery.content}');
  print('Image: ${GroupDelivery.image}');
  print('Member: ${GroupDelivery.member}');
  print('duetime: ${GroupDelivery.duetime.toIso8601String()}');

  final response = await http.post(
    Uri.parse('http://3.144.38.43/GroupDelivery/createGroupDelivery'), // 서버 엔드포인트
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': GroupDelivery.email,
      'title': GroupDelivery.title,
      'content': GroupDelivery.content,
      'image': GroupDelivery.image,
      'member': GroupDelivery.member,
      'duetime': GroupDelivery.duetime.toIso8601String()
    }),
  );

  if (response.statusCode == 201) {
    // 성공적으로 데이터가 추가되었을 때의 처리
    print('Group delivery added successfully');
  } else {
    // 서버 응답 에러 처리
    print('Failed to add group delivery. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to add group delivery');
  }
}

Future<void> updateGroupDelivery(GroupDeliveryModel groupDelivery) async {
  final response = await http.put(
    Uri.parse('http://3.144.38.43/groupdelivery/updategroupdelivery/${groupDelivery.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'id': groupDelivery.id,
      'email': groupDelivery.email,
      'title': groupDelivery.title,
      'content': groupDelivery.content,
      'image': groupDelivery.image,
      'member': groupDelivery.member,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update group buying');
  }
}

Future<void> deleteGroupDelivery(int id) async {
  try {
    final response = await http.delete(
      Uri.parse('http://3.144.38.43/GroupDelivery/deleteGroupDelivery/$id'),
    );

    if (response.statusCode != 200 && response.statusCode != 203) { // 또는 다른 성공 상태 코드
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete group delivery');
    }
  } catch (e) {
    print('Error in deleteGroupDelivery: $e');
    throw e; // 예외를 다시 throw하여 상위에서 처리할 수 있게 함
  }
}