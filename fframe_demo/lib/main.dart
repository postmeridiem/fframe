import 'package:fframe/models/navigation_target.dart';
import 'package:fframe_demo/firebase_config.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:fframe_demo/views/signInPage/signin_page.dart';
import 'package:fframe_demo/views/home/home.dart';
import 'package:fframe_demo/views/suggestion/suggestion.dart';
import 'package:fframe_demo/views/setting/setting.dart';
import 'package:fframe_demo/views/user/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your FlutFrame application.
  @override
  Widget build(BuildContext context) {
    final List<NavigationTarget> authenticatedNavigationTargets = [
      homeNavigationTargets,
      suggestionNavigationTargets,
      settingNavigationTargets,
      usersNavigationTargets,
    ];

    final List<NavigationTarget> unAuthenticatedNavigationTargets = [
      signInPageNavigationTargets,
    ];

    return Fframe(
      firebaseOptions: DefaultFirebaseConfig.platformOptions,
      authenticatedNavigationTargets: authenticatedNavigationTargets,
      unAuthenticatedNavigationTargets: unAuthenticatedNavigationTargets,
    );
  }
}
