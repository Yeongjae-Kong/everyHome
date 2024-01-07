import 'dart:developer';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_model.dart';
import '../user_viewmodel.dart';
import 'kakao_login.dart';

class AuthViewModel {
  final KakaoLogin _kakaoLogin;
  bool isLogined = false;
  User? user;

  AuthViewModel(this._kakaoLogin);

  Future<bool> login() async {
    String state = '';
    isLogined = await _kakaoLogin.login();
    if (isLogined) {
      user = await UserApi.instance.me();
      // String email = user?.kakaoAccount?.email ?? '';
      String userId = user?.id.toString() ?? '';
      print('user: $user');
      if (userId == '') {
        state = 'IDerror';
      } else {
        state = 'ID';
      }
    }

    if (state == 'ID') {
      return true;
    } else {
      return false;
    }
  }

  Future logout() async {
    await _kakaoLogin.logout();
    isLogined = false;
    user = null;
  }
}