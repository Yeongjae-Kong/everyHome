// // File generated by FlutterFire CLI.
// // ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;
//
// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// ```dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// ```
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return web;
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.macOS:
//         return macos;
//       case TargetPlatform.windows:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for windows - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }
//
//   static const FirebaseOptions web = FirebaseOptions(
//     apiKey: 'AIzaSyBVCdvhWNRctUjD5qVszKdCKAlAfiQgFaA',
//     appId: '1:711266435537:web:7fe664dfad402d7b1460f0',
//     messagingSenderId: '711266435537',
//     projectId: 'madcamp-week2-yeongjae-yoonseo',
//     authDomain: 'madcamp-week2-yeongjae-yoonseo.firebaseapp.com',
//     storageBucket: 'madcamp-week2-yeongjae-yoonseo.appspot.com',
//     measurementId: 'G-XBKRC5Q3WC',
//   );
//
//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyAo5Y_IrhH_c_govLD1Nd6CZ24seQl5ISw',
//     appId: '1:711266435537:android:b415dbe94e4a25371460f0',
//     messagingSenderId: '711266435537',
//     projectId: 'madcamp-week2-yeongjae-yoonseo',
//     storageBucket: 'madcamp-week2-yeongjae-yoonseo.appspot.com',
//   );
//
//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'AIzaSyD3DtG3o3X3Uhbn08d9VjDMVZsrBsNxjBM',
//     appId: '1:711266435537:ios:a9d5dabf9d33b45d1460f0',
//     messagingSenderId: '711266435537',
//     projectId: 'madcamp-week2-yeongjae-yoonseo',
//     storageBucket: 'madcamp-week2-yeongjae-yoonseo.appspot.com',
//     iosBundleId: 'com.example.madcampWeek2',
//   );
//
//   static const FirebaseOptions macos = FirebaseOptions(
//     apiKey: 'AIzaSyD3DtG3o3X3Uhbn08d9VjDMVZsrBsNxjBM',
//     appId: '1:711266435537:ios:67e1f4a1c44647b91460f0',
//     messagingSenderId: '711266435537',
//     projectId: 'madcamp-week2-yeongjae-yoonseo',
//     storageBucket: 'madcamp-week2-yeongjae-yoonseo.appspot.com',
//     iosBundleId: 'com.example.madcampWeek2.RunnerTests',
//   );
// }