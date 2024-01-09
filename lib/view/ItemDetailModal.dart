import 'package:flutter/material.dart';
import 'package:madcamp_week2/model/board_model.dart';
import 'package:madcamp_week2/viewmodel/board_viewmodel.dart';

class ItemDetailModal {
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
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )
                      : Container(),
                ),
                SizedBox(height: 10),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                if (isDeletable)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text('삭제'),
                      onPressed: () {
                        // 삭제 버튼이 눌렸을 때 처리할 로직을 여기에 추가
                        _showDeleteDialog(context, id);
                      },
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    child: Text('닫기'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                if (!isDeletable)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text('닫기'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  // 삭제 로직을 처리하는 메서드
  static void _deleteItem(BuildContext context, int id) async {
    try{
      await deleteBoard(id);
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
                    Navigator.pop(context);
                    //여기에 '삭제되었습니다' 라는 snackbar를 보이게 하고 싶어
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

