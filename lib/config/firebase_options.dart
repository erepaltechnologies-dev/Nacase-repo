import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyAm1dHctjF1XLfnjpfFjK-8V9JEFnE1DWs',
        appId: '1:795176445971:web:aa5bc972d3d59c62c477e6',
        messagingSenderId: '795176445971',
        projectId: 'dlawhq-a7ee7',
        authDomain: '"dlawhq-a7ee7.firebaseapp.com',
        storageBucket: 'dlawhq-a7ee7.firebasestorage.app',
        measurementId: 'YOUR_MEASUREMENT_ID',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'YOUR_ANDROID_API_KEY',
          appId: 'YOUR_ANDROID_APP_ID',
          messagingSenderId: 'YOUR_ANDROID_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_IOS_API_KEY',
          appId: 'YOUR_IOS_APP_ID',
          messagingSenderId: 'YOUR_IOS_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
          iosBundleId: 'com.example.yourApp',
        );
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const FirebaseOptions(
          apiKey: 'YOUR_DESKTOP_API_KEY',
          appId: 'YOUR_DESKTOP_APP_ID',
          messagingSenderId: 'YOUR_DESKTOP_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      default:
        return const FirebaseOptions(
          apiKey: 'YOUR_DEFAULT_API_KEY',
          appId: 'YOUR_DEFAULT_APP_ID',
          messagingSenderId: 'YOUR_DEFAULT_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
    }
  }
}