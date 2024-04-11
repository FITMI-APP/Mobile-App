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
    apiKey: 'AIzaSyCbhQS11iPQ5f038yVoFUJ6EedMC1h6Byw',
    appId: '1:318206584052:web:d14f7c56e14938ffdf6aa1',
    messagingSenderId: '318206584052',
    projectId: 'fitmi-d65a1',
    authDomain: 'fitmi-d65a1.firebaseapp.com',
    storageBucket: 'fitmi-d65a1.appspot.com',
    measurementId: 'G-HECQ0WV5ZC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_2mJBvyt-vu3wHYReWfL6-nbs8RI1uGI',
    appId: '1:318206584052:android:1718e8f187706d25df6aa1',
    messagingSenderId: '318206584052',
    projectId: 'fitmi-d65a1',
    storageBucket: 'fitmi-d65a1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaW81PF3fFp_Ya5NMuqQx5Mt3klDZr2JQ',
    appId: '1:318206584052:ios:b180a8b3ed96fdf4df6aa1',
    messagingSenderId: '318206584052',
    projectId: 'fitmi-d65a1',
    storageBucket: 'fitmi-d65a1.appspot.com',
    iosBundleId: 'com.example.grad',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaW81PF3fFp_Ya5NMuqQx5Mt3klDZr2JQ',
    appId: '1:318206584052:ios:9c92e31caab812f6df6aa1',
    messagingSenderId: '318206584052',
    projectId: 'fitmi-d65a1',
    storageBucket: 'fitmi-d65a1.appspot.com',
    iosBundleId: 'com.example.grad.RunnerTests',
  );
}
