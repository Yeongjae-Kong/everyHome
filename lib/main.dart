import 'package:madcamp_week2/notification.dart';
import 'package:madcamp_week2/view/auth_view.dart';
import 'package:madcamp_week2/view/control_view.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:madcamp_week2/view/control_view_ds.dart';
import 'package:madcamp_week2/view/log_out.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var NATIVEAPPKEY = 'eea7d5fa75c446d1cfba82d3f061960e';
  KakaoSdk.init(nativeAppKey: NATIVEAPPKEY);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print('user' + email.toString());
  runApp(MyApp(email));
}

class MyGlobalState extends ChangeNotifier {
  bool itemDeleted = false;

  void deleteItem() {
    itemDeleted = true;
    notifyListeners();
  }

  void resetDeleteFlag() {
    itemDeleted = false;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final String? email;
  const MyApp(this.email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyGlobalState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'madcamp_week2',
        home: email == null ? AuthView() : const ControlViewDS(),
        // home: ControlViewDS(),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   final String? email;
//   const MyApp(this.email, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'madcamp_week2',
//       theme: ThemeData(
//         primarySwatch: Colors.amber,
//       ),
//       home: email == null ? AuthView() : const ControlViewDS(),

      // home: ControlViewDS()
      //   home: email == null? AuthView() : Logout()
      //   home: ControlView()
      //   home: Logout()
//     )
//   }
// }

