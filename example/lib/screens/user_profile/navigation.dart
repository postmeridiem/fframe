import 'package:example/screens/user_profile/screen.dart';
import 'package:fframe/fframe.dart';
// ignore: unused_import
import 'package:flutter/material.dart';

final userProfileNavigationTarget = NavigationTarget(
  path: "profile",
  title: "profile",
  contentPane: const CurrentUserProfile(),
  private: true,
  profilePage: true,
);
