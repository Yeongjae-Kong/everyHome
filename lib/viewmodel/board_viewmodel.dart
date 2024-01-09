import 'dart:convert';
import 'package:madcamp_week2/model/board_model.dart';
import 'package:http/http.dart' as http;

Future<List<BoardModel>> fetchBoards() async{
  final response = await http.get(Uri.parse('http://3.144.38.43/board/fetchall'));

  if (response.statusCode == 200){
    List<dynamic> BoardList = jsonDecode(response.body);
    return BoardList.map((data) => BoardModel.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load board');
  }
}

Future<BoardModel?> addBoard(BoardModel board) async{
  print('Sending request with:');
  print('Email: ${board.email}');
  print('Title: ${board.title}');
  print('Content: ${board.content}');
  print('Image: ${board.image}');

  final response = await http.post(
    Uri.parse('http://3.144.38.43/board/createboard'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': board.email,
      'title': board.title,
      'content': board.content,
      'image': board.image,
    })
  );

  if (response.statusCode == 201){
    print('Board added successfully');
  } else {
    print('Failed to add board. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to add board');
  }
}

Future<void> deleteBoard(int id) async {
  try{
    final response = await http.delete(
      Uri.parse('http://3.144.38.43/board/deleteboard/$id')
    );

    if (response.statusCode != 200 && response.statusCode != 203){
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete board item');
    }
  } catch(e){
    print('Error in deleteboard: $e');
    throw e;
  }
}