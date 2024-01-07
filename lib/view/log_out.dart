import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../viewmodel/auth/auth_viewmodel.dart';
import '../viewmodel/auth/kakao_login.dart';
import '../viewmodel/user_viewmodel.dart';
import 'auth_view.dart';

class Logout extends StatefulWidget {
  Logout({Key? key}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final viewModel = AuthViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그아웃'),
        elevation: 0.0,
      ),
        body: FutureBuilder(
            future: fetchUserByUidWithoutGiven(),
            builder: (context, AsyncSnapshot<UserModel?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          if (snapshot.data!.password == '') {
                            viewModel.logout();
                          }
                          await prefs.clear();
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(MaterialPageRoute(
                              builder: (context) => AuthView()));
                          ;
                          //navigation getoffall 하고 authview로
                        },
                        child: Container(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: const Text('로그아웃',
                                style: TextStyle(fontSize: 16))),
                      ),
                    ],
                  );
                }
              } else {
                return const CircularProgressIndicator();
              }
            })
    );
  }
}
