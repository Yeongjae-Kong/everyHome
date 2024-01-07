import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoticeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // 뷰의 높이를 설정합니다.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '공지사항',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10, // 가로로 스크롤되는 아이템의 개수입니다.
              itemBuilder: (context, index) {
                // 가로로 스크롤되는 아이템들을 여기에 구현합니다.
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 200, // 아이템의 너비를 설정합니다.
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '공지사항 ${index + 1}', // 각 공지사항의 내용입니다.
                      style: TextStyle(fontSize: 16),
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