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
    apiKey: 'AIzaSyDvf3QbFhiAgREZxronZSq6mSQvgy6eDUY',
    appId: '1:755037480980:web:1693369645a73f59f91f01',
    messagingSenderId: '755037480980',
    projectId: 'pumpkin-bites-jvouko',
    authDomain: 'pumpkin-bites-jvouko.firebaseapp.com',
    storageBucket: 'pumpkin-bites-jvouko.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwxhvFhBfJfEpV07Bz3600Blz64vSnhyM',
    appId: '1:755037480980:android:1565f291bef77626f91f01',
    messagingSenderId: '755037480980',
    projectId: 'pumpkin-bites-jvouko',
    storageBucket: 'pumpkin-bites-jvouko.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOaBZEpbOaKfZKIcSBGZM5L_hrxPe1VKI',
    appId: '1:755037480980:ios:b32251b46a92aa41f91f01',
    messagingSenderId: '755037480980',
    projectId: 'pumpkin-bites-jvouko',
    storageBucket: 'pumpkin-bites-jvouko.firebasestorage.app',
    androidClientId: '755037480980-5pcsmbfv4r23fm7vjvdol3fqofk5144g.apps.googleusercontent.com',
    iosClientId: '755037480980-ao5mg8255ser6olop92l9qlve3us2kk1.apps.googleusercontent.com',
    iosBundleId: 'com.example.pumpkinBitesNew',
  );

}