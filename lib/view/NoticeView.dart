import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ItemDetailModal.dart';

class NoticeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '공지사항',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 아이템이 클릭되었을 때의 동작을 정의합니다.
                    String noticeContent = '공지사항 ${index + 1}의 내용입니다.';
                    ItemDetailModal.show(context, noticeContent);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: 350,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '공지사항 ${index + 1}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}