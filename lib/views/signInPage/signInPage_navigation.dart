import 'package:fframe/views/signInPage/signInPage_screen.dart';
import 'package:fframe/models/navigationTarget.dart';

final signInPageNavigationTargets = NavigationTarget(
  contentPane: SignInPage(),
  path: "signin",
  title: "Sign In",
  signInPage: true,
);
