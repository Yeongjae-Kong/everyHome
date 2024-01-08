import 'package:flutter/material.dart';

class ItemDetailModal {
  static void show(BuildContext context, String noticeContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('자세히보기'),
          content: SingleChildScrollView(
            child: Text(noticeContent),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}