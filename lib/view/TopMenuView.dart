import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // '게시판' 카드를 나타내는 위젯
    return Container(
      margin: EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color(0xFFF6F6F6),
        child: InkWell(
          onTap: () {
            // 카드 탭 액션
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.message, size: 80), // 더 큰 아이콘으로 조정
                SizedBox(height: 8),
                Text('게시판', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)), // 더 큰 텍스트로 조정
              ],
            ),
          ),
        ),
      ),
    );
  }
}