import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:madcamp_week2/view/CustomAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Knock extends StatefulWidget {
  @override
  _KnockState createState() => _KnockState();
}

class _KnockState extends State<Knock> with TickerProviderStateMixin { // TickerProviderStateMixin 추가
  late AnimationController _animationController;
  String currentUserRoom = '';


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _loadCurrentUserRoom();
  }

  Future<void> _loadCurrentUserRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserRoom = prefs.getString('room') ?? '';
    });
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpeg'), // 이미지 경로 설정
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
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
                onPressed:() async {
                  int? parsedRoom = int.tryParse(currentUserRoom ?? '');
                  print('parsedRoom: ${parsedRoom}');
                  if (parsedRoom != null) {
                    // 이제 parsedRoom을 정수로 사용할 수 있습니다.
                    _showsendKnockAlert(context, '${parsedRoom + 100}호에게 똑똑 알림을 보내시겠습니까?', parsedRoom+100);
                  } else {
                    // currentUserRoom이 유효한 정수로 변환되지 않은 경우 처리 (선택 사항)
                    print('Invalid room number: $currentUserRoom');
                  }
                  },
                child: Text(
                  "윗집에 똑똑",
                  style: TextStyle(
                    color: Colors.black, // 글자색을 검은색으로 설정
                    fontSize: 16, // 글자를 진하게(Bold) 설정
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow, // 버튼 배경색을 노란색으로 설정
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // 버튼의 패딩
                ),
              ),
              SizedBox(height: 200),
            ],
          )
        ],
      ),
    );
  }
  void _showsendKnockAlert(BuildContext context, String message, int room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 크기를 최소화
              children: [
                Text('$message'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text('예'),
                      onPressed: () {
                        // 삭제 버튼이 눌렸을 때 처리할 로직을 여기에 추가
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 100), () {
                          _playAnimation();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '$room호에게 똑똑 알림을 보냈습니다.',
                              style: TextStyle(color: Colors.black),
                            ),
                            duration: Duration(seconds: 2), // SnackBar 표시 시간 설정
                            backgroundColor: Colors.white,
                          ),
                        );
                      },
                    ),
                    TextButton(
                      child: Text('아니오'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

