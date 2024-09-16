// ignore_for_file: depend_on_referenced_packages
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class SignInPage extends StatefulWidget {
  // ignore: use_super_parameters
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
    Console.log("Opening signIn page", scope: "exampleApp.SignIn", level: LogLevel.prod);

    // List<ProviderConfiguration>? providerConfigs = Fframe.of(context)?.providerConfigs;
    List<GoogleProvider>? providerConfigurations = Fframe.of(context)?.providerConfigs?.where((GoogleProvider providerConfiguration) {
      return providerConfiguration.providerId == "google.com";
    }).toList();
    if (providerConfigurations != null && providerConfigurations.isNotEmpty) {
      GoogleProvider providerConfiguration = providerConfigurations.first as GoogleProvider;
      webClientId = providerConfiguration.clientId;
    }

    if (widget.useFlutterFireUI == false && webClientId != null) {
      //Queue a silent sign in
      silentSignIn();

      //Sign out from Google when signed out from Firebase
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Console.log("User signed out. Sign out from Google as well.", scope: "exampleApp.SignIn", level: LogLevel.prod);
          silentSignOut();
        }
      });

      return Center(
        child: AnimatedCrossFade(
          firstChild: SizedBox(
            width: 200,
            height: 40,
            child: SignInButton(
              Buttons.Google,
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
      Fframe.of(context)!.showErrorPage(context: context, errorText: "Missign auth provider configuration");
    }

    // return AuthStateListener<OAuthController>(
    //   child: OAuthProviderButton(
    //     // or any other OAuthProvider
    //     provider: GoogleProvider(clientId: GOOGLE_CLIENT_ID),
    //   ),
    //   listener: (oldState, newState, ctrl) {
    //     if (newState is SignedIn) {
    //       Navigator.pushReplacementNamed(context, '/profile');
    //     }
    //     return null;
    //   },
    // );

    // return const Padding(
    //   padding: EdgeInsets.only(bottom: 8),
    //   child: Text("aaaaaaaa"),
    // );

    return SignInScreen(
      providers: Fframe.of(context)?.providerConfigs,
      showAuthActionSwitch: false,
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            action == AuthAction.signIn ? widget.title : 'Welcome',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
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
  }

  silentSignOut() async {}

  silentSignIn() async {
    // final GoogleSignInAccount? googleUser = await GoogleSignIn(
    //   clientId: webClientId,
    // ).signInSilently(suppressErrors: true, reAuthenticate: false);

    // if (googleUser != null) {
    //   // Obtain the auth details from the request
    //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    //   // Create a new credential
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );

    //   // Once signed in, return the UserCredential
    //   return await FirebaseAuth.instance.signInWithCredential(credential);
    // }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    Console.log("Trigger the authentication flow", scope: "exampleApp.SignIn", level: LogLevel.prod);
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
