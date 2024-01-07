import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // '무료나눔', '공동배달', '똑똑이' 카드를 나타내는 위젯
    return Row(
      children: [
        _buildCard(icon: Icons.card_giftcard, text: '무료나눔'),
        _buildCard(icon: Icons.local_shipping, text: '공동배달'),
        _buildCard(icon: Icons.notifications, text: '똑똑이'),
      ],
    );
  }

  Widget _buildCard({required IconData icon, required String text}) {
    return Expanded(
      child: Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40),
                SizedBox(height: 8),
                Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}