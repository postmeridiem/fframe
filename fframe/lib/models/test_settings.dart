part of '../fframe.dart';

class TestSettings {
  final FirebaseAuth? firebaseAuth;
  final FirebaseFirestore? firebaseFirestore;

  const TestSettings({
    this.firebaseAuth,
    this.firebaseFirestore,
  });
}