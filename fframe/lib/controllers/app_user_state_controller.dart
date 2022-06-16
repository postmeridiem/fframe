import 'package:fframe/fframe.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final FFrameUser fFrameUser;
  const UserStateSignedIn(this.fFrameUser);

  //Public method to sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  // ignore: avoid_renaming_method_parameters
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserStateSignedIn && o.fFrameUser == fFrameUser;
  }

  @override
  int get hashCode => fFrameUser.hashCode;
}

//Notifier class
class UserStateNotifier extends StateNotifier<UserState> {
  // FFrameUser? fFrameUser;

  UserStateNotifier() : super(const UserStateUnknown()) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null || user.isAnonymous) {
        state = const UserStateSignedOut();
      } else {
        try {
          IdTokenResult idTokenResult = await user.getIdTokenResult();
          List<String>? roles = [];

          Map<String, dynamic>? _claims = idTokenResult.claims;

          if (_claims != null && _claims.containsKey("roles") == true) {
            debugPrint("Has roles in ${_claims["roles"].runtimeType}");

            if ("${_claims["roles"].runtimeType}".toLowerCase() == "JSArray<dynamic>".toLowerCase()) {
              roles = List<String>.from(_claims["roles"]);
            } else if (List<dynamic> == _claims["roles"].runtimeType || List<String> == _claims["roles"].runtimeType) {
              roles = List<String>.from(_claims["roles"]);
            } else {
              //Legacy mode... it's a map..
              Map<String, dynamic>? _rolesMap = Map<String, dynamic>.from(_claims["roles"]);
              _rolesMap.removeWhere((key, value) => value == false);
              roles = List<String>.from(_rolesMap.keys);
            }
          }
          roles = roles.map((role) => role.toLowerCase()).toList();
          debugPrint("User is signed in as ${user.uid} ${user.displayName} with roles: ${roles.join(", ")}");
          state = UserStateSignedIn(FFrameUser.fromFirebaseUser(firebaseUser: user, roles: roles));
        } catch (e) {
          debugPrint("Unable to interpret claims ${e.toString()}");
          state = UserStateSignedIn(FFrameUser.fromFirebaseUser(firebaseUser: user, roles: []));
        }
      }
    });
  }
}
