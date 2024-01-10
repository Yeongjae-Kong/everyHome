import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/main.dart';
import 'package:madcamp_week2/model/board_model.dart';
import 'package:madcamp_week2/viewmodel/board_viewmodel.dart';
import 'package:provider/provider.dart';

import 'control_view_ds.dart';


class ItemDetailModalNotif {
  List<BoardModel> Boards = [];

  static void show(BuildContext context, int id, String title, String content, String imageUrl, bool isDeletable) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Flexible 위젯을 사용하여 이미지 크기를 조절
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(imageUrl)
                ),
                SizedBox(height: 10),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                if (isDeletable)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text('삭제'),
                        onPressed: () {
                          // 삭제 버튼이 눌렸을 때 처리할 로직을 여기에 추가
                          _showDeleteDialog(context, id);
                          // Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('닫기'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                else
                  Center(
                    child: TextButton(
                      child: Text('닫기'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
  // Future를 관리하기 위해 Completer 생성

  // 삭제 로직을 처리하는 메서드
  static void _deleteItem(BuildContext context, int id) async {
    try{
      await deleteBoard(id);
      Provider.of<MyGlobalState>(context, listen: false).deleteItem();
      // MyGlobalState myGlobalState = Provider.of<MyGlobalState>(context, listen: false);
      // myGlobalState.deleteItem();
    } catch (e){
      print('Error deleting board $e');
    }
  }

  static void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 크기를 최소화
              children: [
                Text('삭제하시겠습니까?'),
                SizedBox(height: 16),
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    _deleteItem(context, id);
                    // Provider.of<MyGlobalState>(context, listen: false).itemDeleted;
                    Provider.of<MyGlobalState>(context, listen: false).deleteItem();
                    // Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                    // SnackBar 표시
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('삭제되었습니다.'),
                        duration: Duration(seconds: 2), // SnackBar 표시 시간 설정
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ControlViewDS(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

}

