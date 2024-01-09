import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/view/control_view_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madcamp_week2/view/kakao_auth_join_view.dart';

import 'auth_view.dart';

class CustomAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
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
                height: 60,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset('assets/images/home_icon.png'),
                ),
              ),
            ),
            const Text(
              'our_home',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
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
                      height: 200,
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
                              leading: Icon(Icons.logout), // 아이콘 추가
                              title: Text("로그아웃"),
                              onTap: () async {
                                print("로그아웃 시도");
                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                await prefs.clear();
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                    builder: (context) => AuthView()));
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.edit), // 회원정보 수정 아이콘
                              title: Text("회원정보 수정"),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => KakaoAuthJoinView()),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.person_remove), // 회원탈퇴 아이콘
                              title: Text("회원탈퇴"),
                              onTap: () async {
                                // 회원탈퇴 동작 구현
                                print("회원탈퇴 시도");
                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                await prefs.clear();
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                    builder: (context) => AuthView()));
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
                width: 50,
                height: 50,
                child: Image.asset('assets/images/profile_icon.png'),
              ),
            ),
            ],
        ),
      ),
    );
  }
}