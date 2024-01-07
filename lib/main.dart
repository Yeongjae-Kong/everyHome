import 'package:madcamp_week2/view/auth_view.dart';
import 'package:madcamp_week2/view/control_view.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:madcamp_week2/view/log_out.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var NATIVEAPPKEY = 'eea7d5fa75c446d1cfba82d3f061960e';
  KakaoSdk.init(nativeAppKey: NATIVEAPPKEY);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print('user' + email.toString());
  runApp(MyApp(email));
}

class MyApp extends StatelessWidget {
  final String? email;
  const MyApp(this.email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'madcamp_week2',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: email == null ? AuthView() : const ControlView(),
      //   home: email == null? AuthView() : Logout()
      //   home: ControlView()
      //   home: Logout()
    );
  }
}