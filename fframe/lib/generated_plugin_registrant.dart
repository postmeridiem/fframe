//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering, depend_on_referenced_packages
// ignore_for_file: lines_longer_than_80_chars

import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:cloud_functions_web/cloud_functions_web.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:firebase_analytics_web/firebase_analytics_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:firebase_database_web/firebase_database_web.dart';
import 'package:firebase_storage_web/firebase_storage_web.dart';
import 'package:flutter_facebook_auth_web/flutter_facebook_auth_web.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:sign_in_with_apple_web/sign_in_with_apple_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FirebaseFirestoreWeb.registerWith(registrar);
  FirebaseFunctionsWeb.registerWith(registrar);
  FilePickerWeb.registerWith(registrar);
  FirebaseAnalyticsWeb.registerWith(registrar);
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  FirebaseDatabaseWeb.registerWith(registrar);
  FirebaseStorageWeb.registerWith(registrar);
  FlutterFacebookAuthPlugin.registerWith(registrar);
  GoogleSignInPlugin.registerWith(registrar);
  SignInWithApplePlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
