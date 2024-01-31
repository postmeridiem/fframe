import 'package:fframe/fframe.dart';
import 'package:example/screens/signInPage/signin_page_screen.dart';

final signInPageNavigationTarget = NavigationTarget(
  contentPane: const SignInPage(
    title: 'Welcome to FlutFrame Demooo',
    useFlutterFireUI: true,
  ),
  path: "signin",
  title: "Sign In",
  public: true,
);
