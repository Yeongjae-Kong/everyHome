import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_view.dart';
import 'control_view.dart';

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
                    builder: (BuildContext ctx) => const ControlView(),
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
                    builder: (BuildContext context){
                      return Scaffold(
                        body: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text("로그아웃"),
                                onTap: () async{
                                  print("로그아웃 시도");
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Navigator.of(context, rootNavigator: true)
                                      .pushReplacement(MaterialPageRoute(
                                      builder: (context) => AuthView()));
                                },
                              )
                            ],
                          )
                        )
                      );
                    }
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