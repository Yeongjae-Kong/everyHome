import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/view/control_view_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madcamp_week2/view/kakao_auth_join_view.dart';

import '../viewmodel/user_viewmodel.dart';
import 'auth_view.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16), // 필요에 따라 가로 패딩을 조절하세요
        width: double.infinity,
        height: 60, // 필요에 따라 높이를 조절하세요
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (BuildContext ctx) => const ControlViewDS(),
                  ),
                      (_) => false,
                );
              },
              child: Container(
                height: 40, // 필요에 따라 높이를 조절하세요
                width: 40, // 필요에 따라 너비를 조절하세요
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset('assets/images/home_icon.png'),
                ),
              ),
            ),
            const Text(
              'everyHome',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20, // 필요에 따라 글꼴 크기를 조절하세요
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 150,
                      color: Colors.transparent,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.logout),
                              title: Text("로그아웃"),
                              onTap: () {
                                _showsendAlert(context, '로그아웃하시겠습니까?', false);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.person_remove),
                              title: Text("회원탈퇴"),
                              onTap: () {
                                _showsendAlert(context, '회원탈퇴하시겠습니까?', true);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: 30, // 필요에 따라 너비를 조절하세요
                height: 30, // 필요에 따라 높이를 조절하세요
                child: Image.asset('assets/images/profile_icon.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showsendAlert(BuildContext context, String message, bool delete) {
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
                      onPressed: () async {
                        // 삭제 버튼이 눌렸을 때 처리할 로직을 여기에 추가
                        if (delete == false) {
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(MaterialPageRoute(
                              builder: (context) => AuthView()));
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          await prefs.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '로그아웃 되었습니다.',
                              style: TextStyle(color: Colors.black),
                            ),
                            duration: Duration(seconds: 2), // SnackBar 표시 시간 설정
                            backgroundColor: Colors.white,
                          ),
                        );
                        } else {
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(MaterialPageRoute(
                              builder: (context) => AuthView()));
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          String idString = prefs.getString('u_id') ?? '-1';
                          int id = int.tryParse(idString) ?? -1;
                          await prefs.clear();
                          print('탈퇴 전');
                          deleteUser(id);
                          print('탈퇴 후');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '회원탈퇴 되었습니다.',
                                style: TextStyle(color: Colors.black),
                              ),
                              duration: Duration(seconds: 2), // SnackBar 표시 시간 설정
                              backgroundColor: Colors.white,
                            ),
                          );
                        };
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
