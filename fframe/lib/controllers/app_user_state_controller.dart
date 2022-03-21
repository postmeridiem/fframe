import 'package:fframe/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Possible states
abstract class UserState {
  const UserState();
}

class UserStateUnknown extends UserState {
  const UserStateUnknown();
}

class UserStateSignedOut extends UserState {
  const UserStateSignedOut();
}

class UserStateSignedIn extends UserState {
  final AppUser appUser;
  const UserStateSignedIn(this.appUser);

  //Public method to sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  // ignore: avoid_renaming_method_parameters
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserStateSignedIn && o.appUser == appUser;
  }

  @override
  int get hashCode => appUser.hashCode;
}

//Notifier class
class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(const UserStateUnknown()) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null || user.isAnonymous) {
        // debugPrint('User is currently signed out or anonymous!');
        state = const UserStateSignedOut();
      } else {
        // debugPrint("User is signed in as ${user.uid}::${user.displayName}");
        IdTokenResult idTokenResult = await user.getIdTokenResult(true);
        Map<String, dynamic>? claims = idTokenResult.claims;
        state = UserStateSignedIn(AppUser.fromFirebaseUser(user, claims));
      }
    });
  }
}
