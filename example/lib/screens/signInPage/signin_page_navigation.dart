import 'package:fframe/fframe.dart';
import 'package:example/screens/signInPage/signin_page_screen.dart';

final signInPageNavigationTarget = NavigationTarget(
  contentPane: const SignInPage(
    title: 'Welcome to FlutFrame Demo',
    useFlutterFireUI: false,
  ),
  path: "signin",
  title: "Sign In",
  public: true,
);
