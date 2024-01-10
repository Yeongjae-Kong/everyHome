import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/view/kakao_auth_join_view.dart';
import 'package:madcamp_week2/view/log_out.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../viewmodel/auth/auth_viewmodel.dart';
import '../viewmodel/auth/kakao_login.dart';
import '../viewmodel/user_viewmodel.dart';
import 'auth_join_view.dart';
import 'control_view.dart';
import 'control_view_ds.dart';


class AuthView extends StatelessWidget {
  AuthView({Key? key}): super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                child: Image.asset('assets/images/apartment.jpeg')),
              const SizedBox(height: 15),
              const Text('아파트 커뮤니티 서비스',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87)),
              Padding(
                padding: const EdgeInsets.fromLTRB(45, 30, 45, 30),
                child: CustomLoginForm(formKey: _formKey),
              ),
            ]
          )
        ),
      ),
    );
  }
}
class CustomLoginForm extends StatefulWidget{
  const CustomLoginForm({
    Key? key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey,
  super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  State<CustomLoginForm> createState() => _CustomLoginFormState();
}

class _CustomLoginFormState extends State<CustomLoginForm>{
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context){
    return Form(
        key: widget._formKey,
        child: Column(children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val){
              bool _isValidEmail(String val){
                return RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(val);
              }
              return _isValidEmail(val ?? '') ? null : '올바른 이메일 형식으로 입력해주세요';
            },
            onFieldSubmitted: (val){
              setState(() => email = val.trim());
            },
            onSaved: (val){
              setState(() => email = val!);
            },
            decoration: const InputDecoration(
            labelText: '이메일', hintText: '이메일을 입력해주세요'
            ),
        ),
        const SizedBox(height: 10),
      TextFormField(
          obscureText: true,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) {
            bool _isValidPassword(String val) {
              return RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[a-zA-Z]).{8,}")
                  .hasMatch(val);
            }

            return _isValidPassword(val ?? '')
                ? null
                : '8자리 이상의 영어와 숫자 조합의 비밀번호를 입력해주세요.';
          },
          onFieldSubmitted: (val) {
            setState(() => password = val);
          },
          onSaved: (val) {
            setState(() => password = val!);
          },
          decoration: const InputDecoration(
              labelText: '비밀번호', hintText: '비밀번호를 입력해주세요')
      ),
      const SizedBox(height: 15),
      ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 45),
            Text('로그인', style: TextStyle(fontSize: 16)),
          ],
        ),
        onPressed: () async {
          if (widget._formKey.currentState!.validate()) {
            widget._formKey.currentState!.save();
            log(email);
            Future<UserModel?> currentUser = fetchUserByEmail(email);
            currentUser.then((value) async {
              if (value == null) {
                log('저장된 유저 정보가 없습니다.');
                return const SnackBar(content: Text('저장된 유저 정보가 없습니다.'));
              } else if (value.password == password) {
                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                prefs.setString('email', email);
                prefs.setString('u_id', value.u_id.toString());
                prefs.setString('room', value.room);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                        const ControlViewDS()
                      // Logout()
                    ));
              } else {
                log('비밀번호가 잘못되었습니다.');
              }
            });
          }
        },
      ),
      const SizedBox(height: 45),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("다른 방법으로 로그인하기",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                )),
            const SizedBox(height: 10),
            KakaoLoginButton(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("계정이 없으신가요?",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87)),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => AuthJoinView())));
                    },
                    child: const Text("이메일로 회원가입",
                        style: TextStyle(fontSize: 12, color: Colors.orange)))
              ],
            )
          ],
        )
    ]));
  }
}

class KakaoLoginButton extends StatelessWidget {
  final viewModel = AuthViewModel(KakaoLogin());

  KakaoLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Colors.amber,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          maximumSize: const Size.fromHeight(50)),
      onPressed: () async {
        try {
          log('카카오 버튼이 눌렸습니다.');
          bool value = await viewModel.login();
          if (value) {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (BuildContext ctx) => KakaoAuthJoinView()),
                  (_) => false,
            );
          } else {
            print('로그인에 실패했습니다.');
          }
        } catch (e) {
          // 여기서 e는 발생한 예외입니다.
          print('로그인 중 오류가 발생했습니다: $e');
          // 필요한 경우 사용자에게 오류 메시지를 표시할 수 있습니다.
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/kakaotalk.png', height: 30, width: 30),
          const SizedBox(width: 10),
          const Text('카카오톡으로 로그인하기')
        ],
      ),
    );
  }
}