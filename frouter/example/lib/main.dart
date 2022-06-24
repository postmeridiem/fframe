import 'package:example/navigation_config.dart';
import 'package:example/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FRouterLoader(
      mainScreen: const MainScreen(),
      navigationConfig: navigationConfig,
      // isSignedIn: false,
      routerBuilder: (context) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: FNavigationRouteInformationParser(),
          routerDelegate: FNavigationRouterDelegate(),
        );
      },
    );
  }
}
