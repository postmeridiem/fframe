import 'package:fframe/fframe.dart';
import 'package:example/views/signInPage/signin_page_screen.dart';

final signInPageNavigationTargets = NavigationTarget(
  contentPane: const SignInPage(title: 'Welcome to FlutFrame Demo'),
  path: "signin",
  title: "Sign In",
  signInPage: true,
);
