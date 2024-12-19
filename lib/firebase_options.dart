// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC88S6aQLGkedfElfokox-SGPF17cv28oI',
    appId: '1:628781521493:web:104bcdbedc546b3ef112dc',
    messagingSenderId: '628781521493',
    projectId: 'smartkisannn',
    authDomain: 'smartkisannn.firebaseapp.com',
    databaseURL: 'https://smartkisannn-default-rtdb.firebaseio.com',
    storageBucket: 'smartkisannn.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaHc9rL89St84rdUyQ5U_cN6YF9zVtIIs',
    appId: '1:628781521493:android:98e493985a28750ff112dc',
    messagingSenderId: '628781521493',
    projectId: 'smartkisannn',
    databaseURL: 'https://smartkisannn-default-rtdb.firebaseio.com',
    storageBucket: 'smartkisannn.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHTGB4el-XYusRL8wEHJZEWpjQWhzEiYU',
    appId: '1:628781521493:ios:b8966c0107ad3267f112dc',
    messagingSenderId: '628781521493',
    projectId: 'smartkisannn',
    databaseURL: 'https://smartkisannn-default-rtdb.firebaseio.com',
    storageBucket: 'smartkisannn.firebasestorage.app',
    iosBundleId: 'com.example.smartKisan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDHTGB4el-XYusRL8wEHJZEWpjQWhzEiYU',
    appId: '1:628781521493:ios:b8966c0107ad3267f112dc',
    messagingSenderId: '628781521493',
    projectId: 'smartkisannn',
    databaseURL: 'https://smartkisannn-default-rtdb.firebaseio.com',
    storageBucket: 'smartkisannn.firebasestorage.app',
    iosBundleId: 'com.example.smartKisan',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC88S6aQLGkedfElfokox-SGPF17cv28oI',
    appId: '1:628781521493:web:b0580373db7d6195f112dc',
    messagingSenderId: '628781521493',
    projectId: 'smartkisannn',
    authDomain: 'smartkisannn.firebaseapp.com',
    databaseURL: 'https://smartkisannn-default-rtdb.firebaseio.com',
    storageBucket: 'smartkisannn.firebasestorage.app',
  );
}