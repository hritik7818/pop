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
    apiKey: 'AIzaSyAoFB5A0l0RweFTRHDYKuML7qOJigzAujU',
    appId: '1:853393913215:web:c2180f147d3490a22f564a',
    messagingSenderId: '853393913215',
    databaseURL: "https://pop-game-ec6f2-default-rtdb.firebaseio.com",
    projectId: 'pop-game-ec6f2',
    authDomain: 'pop-game-ec6f2.firebaseapp.com',
    storageBucket: 'pop-game-ec6f2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC384L4AQRBN5zgAZFKDa0cwadVepIqzO0',
    appId: '1:853393913215:android:a5cdaaeace255e932f564a',
    messagingSenderId: '853393913215',
    databaseURL: "https://pop-game-ec6f2-default-rtdb.firebaseio.com",
    projectId: 'pop-game-ec6f2',
    storageBucket: 'pop-game-ec6f2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2o7dl2Xo17JFjto_HHl5C5pUNv8Dnlq0',
    appId: '1:853393913215:ios:21aa6ab234e98c202f564a',
    messagingSenderId: '853393913215',
    projectId: 'pop-game-ec6f2',
    storageBucket: 'pop-game-ec6f2.appspot.com',
    iosClientId:
        '853393913215-inmtn3e079ht3nk18or0kbcp8n9hgkva.apps.googleusercontent.com',
    iosBundleId: 'com.example.pop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA2o7dl2Xo17JFjto_HHl5C5pUNv8Dnlq0',
    appId: '1:853393913215:ios:21aa6ab234e98c202f564a',
    messagingSenderId: '853393913215',
    projectId: 'pop-game-ec6f2',
    storageBucket: 'pop-game-ec6f2.appspot.com',
    iosClientId:
        '853393913215-inmtn3e079ht3nk18or0kbcp8n9hgkva.apps.googleusercontent.com',
    iosBundleId: 'com.example.pop',
  );
}
