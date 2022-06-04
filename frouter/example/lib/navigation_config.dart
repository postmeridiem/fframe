import 'package:example/pages/error_page.dart';
import 'package:example/pages/fake_login.dart';
import 'package:example/screens/document_sceen.dart';
import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';

final NavigationConfig navigationConfig = NavigationConfig(
  navigationTargets: [
    NavigationTarget(
      path: "path1",
      title: "Path 1",
      contentPane: const DocumentScreen(),
      destination: const Destination(
        icon: Icon(Icons.lock),
        label: Text('Item 1'),
      ),
      public: false,
      landingPage: true,
    ),
    NavigationTarget(
        path: "path2",
        title: "Path 2",
        contentPane: const DocumentScreen(),
        destination: const Destination(
          icon: Icon(Icons.lock),
          label: Text('Item 2'),
        ),
        roles: [
          'User'
        ],
        navigationTabs: [
          NavigationTab(
            title: "Tab 1",
            path: "tab1",
            contentPane: const DocumentScreen(),
          ),
          NavigationTab(
            title: "Tab 2",
            path: "tab2",
            contentPane: const DocumentScreen(),
          ),
          NavigationTab(
            title: "Tab 3",
            path: "tab3",
            contentPane: const DocumentScreen(),
          )
        ]),
    NavigationTarget(
      path: "path3",
      title: "Path 3",
      contentPane: const DocumentScreen(),
      destination: const Destination(
        icon: Icon(Icons.arrow_forward),
        label: Text('Item 3'),
      ),
      public: true,
      landingPage: true,
    ),
    NavigationTarget(
      path: "path4",
      title: "Path 4",
      contentPane: const DocumentScreen(),
      destination: const Destination(
        icon: Icon(Icons.alternate_email),
        label: Text('Item 4'),
      ),
      public: true,
      private: false,
      landingPage: true,
    ),
  ],
  signInConfig: SignInConfig(
    signInTarget: NavigationTarget(
      path: "login",
      title: "Login",
      contentPane: const FakeLogin(),
      destination: const Destination(
        icon: Icon(Icons.login),
        label: Text('Login'),
      ),
    ),
  ),
  errorPage: NavigationTarget(
    path: "404",
    title: "Error",
    contentPane: const ErrorPage(),
    public: true,
  ),
);
