import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:madcamp_week2/view/CustomAppBar.dart';

class Knock extends StatefulWidget {
  @override
  _KnockState createState() => _KnockState();
}

class _KnockState extends State<Knock> with TickerProviderStateMixin { // TickerProviderStateMixin 추가
  late AnimationController _animationController;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAppBar(),
          Spacer(),
          Center(
            child: Lottie.asset(
              'assets/lottie/bellanimation.json',
              controller: _animationController,
              onLoaded: (composition) {
                _animationController
                  ..duration = composition.duration
                  ..stop(); // 처음에 애니메이션을 멈춥니다.
              },
            ),
          ),
          ElevatedButton(
            onPressed: _playAnimation, // 버튼 클릭 시 애니메이션 재생
            child: Text("똑똑", style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow, // 버튼 배경색을 노란색으로 설정
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // 버튼의 패딩
            ),
          ),
          SizedBox(height: 200),
        ],
      ),
    );
  }
}