import 'package:flutter/foundation.dart';

import '../fframe.dart';

class AuthenticationWatch {
  // For Authentication related functions you need an instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  This getter will be returning a Stream of User object.
  //  It will be used to check if the user is logged in or not.
  Stream<User?> get authStateChange => _auth.authStateChanges();
}

final authenticationWatchProvider = Provider<AuthenticationWatch>((ref) {
  return AuthenticationWatch();
});

final authStateProvider = StreamProvider<User?>((ref) {
  Stream<User?> provider = ref.watch(authenticationWatchProvider).authStateChange;
  return provider;
});

// // final userProvider = FutureProvider<User?>((ref) async {
// //   User? user = ref.watch(authStateProvider).value;
// //   NavigationNotifier navigationNotifier = ref.read(navigationProvider);
// //   if (user == null && navigationNotifier.isSignedIn == true) {
// //     debugPrint("User is null, but the UI state is still signed in.");
// //     ref.read(navigationProvider).signOut();
// //   } else if (user != null && navigationNotifier.isSignedIn == false) {
// //     debugPrint("user!=null");
// //     navigationNotifier.signIn();
// //   }
// //   return user;
// // });

// //  This is a FutureProvider that will be used to check whether the firebase has been initialized or not
// final firebaseinitializerProvider = FutureProvider.family<FirebaseApp, FirebaseOptions>((ref, firebaseOptions) async {
//   return await Firebase.initializeApp(options: firebaseOptions);
// });


// //  This is a FutureProvider that will initialize the l10Config //TODO: Create a parser
// final l10InitializeProvider = FutureProvider.family<Map<String, dynamic>, L10nConfig>((ref, l10nConfig) async {
//   return await L10nReader.read(context, l10nConfig);
// });