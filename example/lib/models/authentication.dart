import 'package:fframe/components/auth/decorations.dart';
import 'package:fframe/fframe.dart';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleAuthProvider googleProvider = GoogleAuthProvider();

final providerConfigs = [
  const GoogleProviderConfiguration(clientId: ''),
  const EmailProviderConfiguration(),
  // emailLinkProviderConfig,
  // const PhoneProviderConfiguration(),
  // const AppleProviderConfiguration(),
  // const FacebookProviderConfiguration(clientId: FACEBOOK_CLIENT_ID),
  // const TwitterProviderConfiguration(
  //   apiKey: TWITTER_API_KEY,
  //   apiSecretKey: TWITTER_API_SECRET_KEY,
  //   redirectUri: TWITTER_REDIRECT_URI,
  // ),
];

//TODO => configure

final emailLinkProviderConfig = EmailLinkProviderConfiguration(
  actionCodeSettings: ActionCodeSettings(
    url: '',
    handleCodeInApp: true,
    androidMinimumVersion: '12',
    androidPackageName: '',
    iOSBundleId: '',
  ),
);

// var _googleSignIn = GoogleSignIn();
// final result = await _googleSignIn.signIn();
// final ggAuth = await result!.authentication;
// debugPrint(ggAuth.idToken);
// debugPrint(ggAuth.accessToken);

class AuthenticationComponents {
  final BuildContext context;
  final String title;

  AuthenticationComponents(this.context, this.title);

  Widget signInScreen() {
    return SignInScreen(
      actions: [
        ForgotPasswordAction((context, email) {
          Navigator.pushNamed(
            context,
            '/forgot-password',
            arguments: {'email': email},
          );
        }),
        VerifyPhoneAction((context, _) {
          Navigator.pushNamed(context, '/phone');
        }),
        // AuthStateChangeAction<SignedIn>((context, state) {
        //   // Navigator.pushReplacementNamed(context, '/');
        // }),
        EmailLinkSignInAction((context) {
          Navigator.pushReplacementNamed(context, '/email-link-sign-in');
        }),
      ],
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
      footerBuilder: (context, action) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              // TODO: add a page for unauthenticated users for ToS
              action == AuthAction.signIn ? 'By signing in, you agree to our terms and conditions.' : 'SHOULD NEVER BE AVAILABLE',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
      providerConfigs: providerConfigs,
    );
  }

  Widget phoneInputScreen() {
    return PhoneInputScreen(
      actions: [
        SMSCodeRequestedAction((context, action, flowKey, phone) {
          Navigator.of(context).pushReplacementNamed(
            '/sms',
            arguments: {
              'action': action,
              'flowKey': flowKey,
              'phone': phone,
            },
          );
        }),
      ],
      headerBuilder: headerIcon(Icons.phone),
      sideBuilder: sideIcon(Icons.phone),
    );
  }

  Widget smsCodeInputScreen() {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return SMSCodeInputScreen(
      // actions: [
      //   AuthStateChangeAction<SignedIn>((context, state) {
      //     Navigator.of(context).pushReplacementNamed('/');
      //   })
      // ],
      flowKey: arguments?['flowKey'],
      action: arguments?['action'],
      headerBuilder: headerIcon(Icons.sms_outlined),
      sideBuilder: sideIcon(Icons.sms_outlined),
    );
  }

  Widget profileScreen() {
    return ProfileScreen(
      providerConfigs: providerConfigs,
      actions: [
        SignedOutAction((context) {
          Navigator.pushReplacementNamed(context, '/');
        }),
      ],
    );
  }

  Widget forgotPassword() {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return ForgotPasswordScreen(
      email: arguments?['email'],
      headerMaxExtent: 200,
      headerBuilder: headerIcon(Icons.lock),
      sideBuilder: sideIcon(Icons.lock),
    );
  }

  Widget emailLinkSignIn() {
    return EmailLinkSignInScreen(
      // actions: [
      //   AuthStateChangeAction<SignedIn>((context, state) {
      //     Navigator.pushReplacementNamed(context, '/profile');
      //   }),
      // ],
      config: emailLinkProviderConfig,
      headerMaxExtent: 200,
      headerBuilder: headerIcon(Icons.link),
      sideBuilder: sideIcon(Icons.link),
    );
  }
}

class GoogleSignInWidget extends StatefulWidget {
  const GoogleSignInWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GoogleSignInWidgetState();
}

class GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: SignInButton(
                Buttons.GoogleDark,
                text: 'Sign In',
                onPressed: _signInWithGoogle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Signing into Google.
  Future<void> _signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // var googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(googleAuthCredential);
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google: $e'),
        ),
      );
    }
  }
}
