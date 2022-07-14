import 'package:fframe/components/auth/decorations.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    debugPrint("Load the sign in page");
    return SignInScreen(
      providerConfigs: Fframe.of(context)?.providerConfigs,
      showAuthActionSwitch: false,
      headerBuilder: headerImage('assets/images/flutter_mono.png'),
      sideBuilder: sideImage('assets/images/flutter_mono.png'),
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            action == AuthAction.signIn ? title : 'Welcome',
            textAlign: TextAlign.center,
          ),
        );
      },
      // footerBuilder: (context, action) {
      //   return Center(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 20),
      //       child: Text(

      //         action == AuthAction.signIn ? 'By signing in, you agree to our terms and conditions.' : 'SHOULD NEVER BE AVAILABLE',
      //         style: const TextStyle(color: Colors.grey),
      //       ),
      //     ),
      //   );
      // },
    );
  }
}
