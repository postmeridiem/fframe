import 'package:fframe/fframe.dart';
import 'package:fframe_demo/views/signInPage/signin_page_screen.dart';

final signInPageNavigationTargets = NavigationTarget(
  contentPane: const SignInPage(title: 'Welcome to WutFrame'),
  path: "signin",
  title: "Sign In",
  signInPage: true,
);
