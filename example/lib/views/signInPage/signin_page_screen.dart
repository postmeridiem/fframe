import 'package:fframe/components/auth/authentication.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    debugPrint("Load the sign in page");
    return AuthenticationComponents(context, title).signInScreen();
  }
}
