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
    apiKey: 'AIzaSyDW8j-0Gn9HVULk-juI8Riz9xGgctRnb0g',
    appId: '1:805199304111:web:5788a54c445ff7619f8b5a',
    messagingSenderId: '805199304111',
    projectId: 'for-flutter-9a5ed',
    authDomain: 'for-flutter-9a5ed.firebaseapp.com',
    storageBucket: 'for-flutter-9a5ed.appspot.com',
    measurementId: 'G-LNSXC2G614',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5QzQ-vE9WS_fi4JokV9Sb8DG8afhJOqc',
    appId: '1:805199304111:android:77b3e45ae7c234a69f8b5a',
    messagingSenderId: '805199304111',
    projectId: 'for-flutter-9a5ed',
    storageBucket: 'for-flutter-9a5ed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCAOQUt1bC8gOTLSeNXYRJYB-8HdCNMJOQ',
    appId: '1:805199304111:ios:c692d24e69afacf09f8b5a',
    messagingSenderId: '805199304111',
    projectId: 'for-flutter-9a5ed',
    storageBucket: 'for-flutter-9a5ed.appspot.com',
    iosClientId: '805199304111-d8qhvgubkio25atpr6hia9is63jqcfon.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterTestForVs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCAOQUt1bC8gOTLSeNXYRJYB-8HdCNMJOQ',
    appId: '1:805199304111:ios:c692d24e69afacf09f8b5a',
    messagingSenderId: '805199304111',
    projectId: 'for-flutter-9a5ed',
    storageBucket: 'for-flutter-9a5ed.appspot.com',
    iosClientId: '805199304111-d8qhvgubkio25atpr6hia9is63jqcfon.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterTestForVs',
  );
}
