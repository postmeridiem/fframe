import 'package:fframe/fframe.dart';
import 'package:flutter/foundation.dart';
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
  // AppUser? appUser;

  UserStateNotifier() : super(const UserStateUnknown()) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null || user.isAnonymous) {
        state = const UserStateSignedOut();
      } else {
        IdTokenResult idTokenResult = await user.getIdTokenResult();
        List<String>? roles;

        Map<String, dynamic>? _claims = idTokenResult.claims;
        if (_claims != null && _claims.containsKey("roles") == true) {
          if (List<dynamic> == _claims["roles"].runtimeType || List<String> == _claims["roles"].runtimeType) {
            roles = List<String>.from(_claims["roles"]);
          } else {
            //Legacy mode... it's a map...
            Map<String, dynamic>? _rolesMap = Map<String, dynamic>.from(_claims["roles"]);
            _rolesMap.removeWhere((key, value) => value == false);
            roles = List<String>.from(_rolesMap.keys);
          }
        }
        debugPrint("User is signed in as ${user.uid} ${user.displayName} with roles: ${roles?.join(", ") ?? "-"}");
        state = UserStateSignedIn(AppUser.fromFirebaseUser(firebaseUser: user, roles: roles));
      }
    });
  }
}
