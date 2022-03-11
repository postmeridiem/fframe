import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        apiKey: "",
        authDomain: "",
        databaseURL: "",
        projectId: "",
        storageBucket: "",
        messagingSenderId: "",
        appId: "",
        measurementId: "",
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      //JS/AZ => not configured
      return const FirebaseOptions(
        apiKey: '',
        appId: '',
        messagingSenderId: '',
        projectId: '',
        authDomain: '',
        iosBundleId: '',
        databaseURL: '',
        iosClientId: '',
        androidClientId: '',
        storageBucket: '',
      );
    } else {
      // Android
      //JS/AZ => not configured
      return const FirebaseOptions(
        apiKey: '',
        appId: '',
        messagingSenderId: '',
        projectId: '',
        authDomain: '',
        databaseURL: '',
        androidClientId: '',
      );
    }
  }
}
