import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/view/control_view.dart';
import 'package:madcamp_week2/view/log_out.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../viewmodel/user_viewmodel.dart';
import 'control_view_ds.dart';

class KakaoAuthJoinView extends StatelessWidget {
  KakaoAuthJoinView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 45, right: 45),
          child: CustomJoinForm(formKey: _formKey),
        ),
      ),
    );
  }
}

class CustomJoinForm extends StatefulWidget {
  const CustomJoinForm({
    Key? key,
    required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  State<CustomJoinForm> createState() => _CustomJoinFormState();
}

class _CustomJoinFormState extends State<CustomJoinForm> {
  String room = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget._formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            onSaved: (val) {
              setState(() => room = val!.trim());
            },
            autocorrect: false,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              bool _isValidName(String val) {
                return RegExp(r"^[0-9()]+[0-9()]+[0-9()\s]$").hasMatch(val);
              }

              return _isValidName(val ?? '') ? null : '세 글자 이상 입력해주세요';
            },
            onFieldSubmitted: (val) {
              setState(() => room = val.trim());
            },
            decoration:
            const InputDecoration(labelText: '방호수', hintText: '번호를 입력해주세요'),
          ),
          const SizedBox(height: 5),
          TextFormField(
            onSaved: (val) {
              setState(() => email = val!.trim());
            },
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              bool _isValidEmail(String val) {
                return RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(val);
              }

              return _isValidEmail(val ?? '') ? null : '올바른 이메일 형식으로 입력해주세요';
            },
            onFieldSubmitted: (val) {
              setState(() => email = val.trim());
            },
            decoration: const InputDecoration(
                labelText: '이메일', hintText: '이메일을 입력해주세요'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 45),
                Text('등록하기', style: TextStyle(fontSize: 16)),
              ],
            ),
            onPressed: () {
              // Navigator.of(context).pushAndRemoveUntil(
              //     CupertinoPageRoute(
              //         builder: (BuildContext ctx) => const ControlView()),
              //         (_) => false);
              if (widget._formKey.currentState!.validate()) {
                widget._formKey.currentState!.save();
                //server의 유저정보와 같은 것이 있는지 체크
                Future<UserModel?> currentUser = fetchUserByEmail(email);
                currentUser.then((value) async {
                  if (value == null) {
                    log('해당 이메일은 등록되지 않은 새 이메일입니다!!');
                    Future<UserModel> futureNewUser = addUser(UserModel(
                        u_id: -1,
                        room: room,
                        // username: '',
                        // name: name,
                        email: email,
                        password: '',
                        ));
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('u_id', value?.u_id?.toString() ?? '');
                    prefs.setString('room', room);
                    prefs.setString('email', email);
                    print('$room, $email, ${value?.u_id}');
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (BuildContext ctx) =>
                            const ControlView()
                          // Logout()
                        ),
                            (_) => false);
                  } else {
                    log('해당 이메일은 이미 등록되었습니다...');
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('u_id', value?.u_id?.toString() ?? '');
                    prefs.setString('room', room);
                    prefs.setString('email', email);
                    print('$room, $email, ${value?.u_id}');
                    const SnackBar(
                        content: Text('동일한 이메일이 이미 존재합니다'));
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                        builder: (BuildContext ctx) =>
                    const ControlViewDS()),
                    (_) => false);
                  }
                });
              }
            },
          ),
        ]));
  }
}
