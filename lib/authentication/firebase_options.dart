// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClZFC7LzMNWYYZ64M1KULKGNR8n1stVyE',
    appId: '1:1052129112959:android:9768d69326a24b447ca04a',
    messagingSenderId: '1052129112959',
    projectId: 'linepay-fa6ef',
    storageBucket: 'linepay-fa6ef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNumBqoX8Yho5nz98Lu1auuf20p1zZrXA',
    appId: '1:1052129112959:ios:914a2df9cd7866097ca04a',
    messagingSenderId: '1052129112959',
    projectId: 'linepay-fa6ef',
    storageBucket: 'linepay-fa6ef.appspot.com',
    iosClientId: '1052129112959-cjekfpmf439v39vejhpjivuh6kia6buh.apps.googleusercontent.com',
    iosBundleId: 'com.coffeehousecuts.linepay',
  );
}
