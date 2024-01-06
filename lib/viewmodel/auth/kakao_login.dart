import 'dart:developer';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLogin {
  Future<bool> login() async {
    print("카카오로그인 시도");
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      print("카카오톡 설치됨");
      if (isInstalled) {
        try {
          print("카카오 로그인 시도");
          await UserApi.instance.loginWithKakaoTalk();
          log("카카오톡 로그인 성공");
          return true;
        } catch (e) {
          print("$e");
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          print("$e");
          return false;
        }
      }
    } catch (e) {
      print("$e");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }
}
