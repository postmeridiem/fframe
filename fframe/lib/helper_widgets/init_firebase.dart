import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class InitializeFirebase extends StatelessWidget {
  const InitializeFirebase({Key? key, required this.firebaseOptions, required this.child, required this.navigationConfig}) : super(key: key);
  final FirebaseOptions firebaseOptions;
  final NavigationConfig navigationConfig;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: firebaseOptions,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        debugPrint("Initialize Firebase");
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return navigationConfig.waitPage.contentPane ?? const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return child;
        }
      },
    );
  }
}
