// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCV0sl43z2HVgwmnKtIHVDuFYMr47-PEts',
    appId: '1:408590004796:web:1a15356c6410bcc53f4939',
    messagingSenderId: '408590004796',
    projectId: 'vedicpurohit-d68c1',
    authDomain: 'vedicpurohit-d68c1.firebaseapp.com',
    databaseURL: 'https://vedicpurohit-d68c1-default-rtdb.firebaseio.com',
    storageBucket: 'vedicpurohit-d68c1.appspot.com',
    measurementId: 'G-RGZE91RCKR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkByrZazrbsGH8pBFDUpKovxO-HSy3sf0',
    appId: '1:408590004796:android:a1c768b073322b903f4939',
    messagingSenderId: '408590004796',
    projectId: 'vedicpurohit-d68c1',
    databaseURL: 'https://vedicpurohit-d68c1-default-rtdb.firebaseio.com',
    storageBucket: 'vedicpurohit-d68c1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwcFAC4LHauQvAupXO-n_6EJYF4Onupfo',
    appId: '1:408590004796:ios:09d775a3c9b124623f4939',
    messagingSenderId: '408590004796',
    projectId: 'vedicpurohit-d68c1',
    databaseURL: 'https://vedicpurohit-d68c1-default-rtdb.firebaseio.com',
    storageBucket: 'vedicpurohit-d68c1.appspot.com',
    androidClientId: '408590004796-050hfub1kl5gj6p99b6at1g0vpfr7irg.apps.googleusercontent.com',
    iosBundleId: 'com.example.kotlinTest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCwcFAC4LHauQvAupXO-n_6EJYF4Onupfo',
    appId: '1:408590004796:ios:49b7d66c3f71ad163f4939',
    messagingSenderId: '408590004796',
    projectId: 'vedicpurohit-d68c1',
    databaseURL: 'https://vedicpurohit-d68c1-default-rtdb.firebaseio.com',
    storageBucket: 'vedicpurohit-d68c1.appspot.com',
    androidClientId: '408590004796-050hfub1kl5gj6p99b6at1g0vpfr7irg.apps.googleusercontent.com',
    iosBundleId: 'com.example.kotlinTest.RunnerTests',
  );
}
