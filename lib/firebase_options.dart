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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCo5U816T8ljuqPq-Px5dksoPO2dAp9ROM',
    appId: '1:916490951809:web:090a56d25da19fa9c48180',
    messagingSenderId: '916490951809',
    projectId: 'aqua-terra-manager',
    authDomain: 'aqua-terra-manager.firebaseapp.com',
    storageBucket: 'aqua-terra-manager.appspot.com',
    measurementId: 'G-L8F25W7VCK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJ2KdfAujOsHan46vxXOAXLK7kd0BMWT4',
    appId: '1:916490951809:android:595ce273296849eec48180',
    messagingSenderId: '916490951809',
    projectId: 'aqua-terra-manager',
    storageBucket: 'aqua-terra-manager.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJAR4IRd4TQwHNyJYzdTnWTcybRiMlXKw',
    appId: '1:916490951809:ios:e98eee858b190029c48180',
    messagingSenderId: '916490951809',
    projectId: 'aqua-terra-manager',
    storageBucket: 'aqua-terra-manager.appspot.com',
    iosClientId:
        '916490951809-vnoll94i4f711cka611a1g5ngm16dgi4.apps.googleusercontent.com',
    iosBundleId: 'com.reinekezepner.aquaTerraManager',
  );
}
