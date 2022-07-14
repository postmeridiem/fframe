import 'package:example/pages/error_page.dart';
import 'package:fframe/components/auth/decorations.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    Key? key,
    required this.title,
    this.useFlutterFireUI = true,
  }) : super(key: key);
  final String title;
  final bool useFlutterFireUI;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isSigningIn = false;
  String? webClientId;

  @override
  Widget build(BuildContext context) {
    debugPrint("Load the sign in page");

    // List<ProviderConfiguration>? providerConfigs = Fframe.of(context)?.providerConfigs;
    List<ProviderConfiguration>? providerConfigurations = Fframe.of(context)?.providerConfigs?.where((ProviderConfiguration providerConfiguration) {
      return providerConfiguration.providerId == "google.com";
    }).toList();
    if (providerConfigurations != null && providerConfigurations.isNotEmpty) {
      GoogleProviderConfiguration providerConfiguration = providerConfigurations.first as GoogleProviderConfiguration;
      webClientId = providerConfiguration.clientId;
    }

    if (widget.useFlutterFireUI == false && webClientId != null) {
      return Center(
        child: AnimatedCrossFade(
          firstChild: SizedBox(
            width: 200,
            height: 40,
            child: SignInButton(
              Buttons.Google,
              text: "Sign in with Google",
              onPressed: () {
                setState(() {
                  isSigningIn = true;
                });
                signInWithGoogle();
              },
            ),
          ),
          secondChild: const SizedBox(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
          crossFadeState: isSigningIn ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      );
    }

    if (Fframe.of(context)?.providerConfigs == null || (Fframe.of(context)?.providerConfigs != null && Fframe.of(context)!.providerConfigs!.isEmpty)) {
      Fframe.of(context)!.showError(context: context, errorText: "Missign auth provider configuration");
    }

    return SignInScreen(
      providerConfigs: Fframe.of(context)?.providerConfigs,
      showAuthActionSwitch: false,
      headerBuilder: headerImage('assets/images/flutter_mono.png'),
      sideBuilder: sideImage('assets/images/flutter_mono.png'),
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            action == AuthAction.signIn ? widget.title : 'Welcome',
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: webClientId,
    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
