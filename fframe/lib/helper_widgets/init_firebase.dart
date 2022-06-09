import 'package:fframe/fframe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frouter/models/navigation_config.dart';

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
            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if (user == null) {
                //As frouter is not accesible this high in the tree, speak to the notifier directly
                navigationNotifier.signOut();
                // FRouter.of(context).logout();
              } else {
                //As frouter is not accesible this high in the tree, speak to the notifier directly
                navigationNotifier.signIn(roles: ["user"]);
                // FRouter.of(context).login();
              }
            });

            //Until the auth state is known..... just keep spinngn
            return child;
          // return navigationConfig.waitPage.contentPane!; // ?? const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
