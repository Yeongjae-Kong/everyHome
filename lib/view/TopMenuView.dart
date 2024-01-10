import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/view/GroupDelivery.dart';
import 'package:madcamp_week2/view/GroupBuying.dart';
import 'package:madcamp_week2/view/Knock.dart';

class TopMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCard(
          icon: Icons.card_giftcard,
          text: '공동구매',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GroupBuying()),
            );
          },
        ),
        _buildCard(
          icon: Icons.local_shipping,
          text: '공동배달',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GroupDelivery()),
            );
          },
        ),
        _buildCard(
            icon: Icons.notifications,
            text: '똑똑',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Knock()),
              );
            }),
      ],
    );
  }

  // Widget _buildCard({required IconData icon, required String text, required VoidCallback onTap}) {
  //   return Expanded(
  //     child: Container(
  //       margin: EdgeInsets.all(8),
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15.0),
  //         ),
  //         child: InkWell(
  //           onTap: onTap,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(icon, size: 40),
  //               SizedBox(height: 8),
  //               Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildCard({required IconData icon, required String text, required VoidCallback onTap}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: EdgeInsets.all(16), // Adjust padding as needed
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Card(
                elevation: 0, // No elevation for the inner card
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
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
          ),
        ),
      ),
    );
  }

}