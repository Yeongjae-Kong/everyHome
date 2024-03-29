// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:glassmorphism/glassmorphism.dart';
// import 'package:madcamp_week2/view/CustomAppBar.dart';
// import 'package:madcamp_week2/view/TopMenuView.dart';
// import 'package:madcamp_week2/view/NoticeView.dart';
//
// class ControlView extends StatefulWidget {
//   const ControlView({Key? key}) : super(key: key);
//
//   @override
//   _ControlViewState createState() => _ControlViewState();
// }
//
// class _ControlViewState extends State<ControlView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomAppBar(), // 기존에 있던 CustomAppBar 위젯
//           NoticeView(), // 공지사항 뷰를 추가
//           Expanded(
//             flex: 2,
//             child: TopMenuView(), // 상단 메뉴 뷰
//           ),
//           Expanded(
//             flex: 3,
//             child: Container(
//               color: Colors.white.withOpacity(0.1),
//             ), // 게시판 뷰
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:madcamp_week2/view/CustomAppBar.dart';
import 'package:madcamp_week2/view/TopMenuView.dart';
import 'package:madcamp_week2/view/NoticeView.dart';

class ControlView extends StatefulWidget {
  const ControlView({Key? key}) : super(key: key);

  @override
  _ControlViewState createState() => _ControlViewState();
}

class _ControlViewState extends State<ControlView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/background.jpeg', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Stacked Widgets
          Column(
            children: [
              CustomAppBar(), // Your existing CustomAppBar widget
              NoticeView(), // Your existing NoticeView widget
              Expanded(
                flex: 2,
                child: TopMenuView(), // Your existing TopMenuView widget
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                ), // Your existing Container widget for the board view
              ),
            ],
          ),
        ],
      ),
    );
  }
}
