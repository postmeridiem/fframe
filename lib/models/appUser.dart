import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppUser {
  AppUser({required this.uid, this.displayName, this.email, this.photoUrl, required this.metaData, this.claims});

  final String? displayName;
  final String uid;
  final String? email;
  final String? photoUrl;
  final UserMetadata metaData;
  final Map<String, dynamic>? claims;

  factory AppUser.fromFirebaseUser(User firebaseUser, Map<String, dynamic>? claims) {
    return AppUser(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
      metaData: firebaseUser.metadata,
      claims: claims,
    );
  }
}
