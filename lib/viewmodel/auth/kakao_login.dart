import 'dart:developer';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLogin {
  Future<bool> login() async {
    log("카카오로그인 시도");
    print(await KakaoSdk.origin);
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      log("카카오톡 설치됨");
      if (isInstalled) {
        try {
          log("카카오 로그인 시도");
          await UserApi.instance.loginWithKakaoTalk();
          log("카카오톡 로그인 성공");
          return true;
        } catch (e) {
          log("카카오톡 로그인 에러: ${e.toString()}");
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          log("카카오 계정으로 로그인 성공");
          return true;
        } catch (e) {
          log("카카오 계정 로그인 에러: ${e.toString()}");
          return false;
        }
      }
    } catch (e) {
      log("카카오 로그인 시도 에러: ${e.toString()}");
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