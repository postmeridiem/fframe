part of fframe;

// class AuthenticationWatch {
//   // For Authentication related functions you need an instance of FirebaseAuth

//   //  This getter will be returning a Stream of User object.
//   //  It will be used to check if the user is logged in or not.
//   Stream<User?> get authStateChange => FirebaseAuth.instance.authStateChanges();
// }

// class UserObjectWatch {
//   // For Aucation related functions you need an instance of FirebaseAuth
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //  This getter will be returning a Stream of User object.
//   //  It will be used to check if the user is logged in or not.
//   Stream<User?> get userStateChange => _auth.userChanges();
// }

// final authenticationWatchProvider = Provider<AuthenticationWatch>((ref) {
//   return AuthenticationWatch();
// });

// final userChangeProvider = StreamProvider<User?>((ref) async* {
//   return ref.watch(UserObjectWatch).;
// });

// final authStateWatchProvider = Provider<UserObjectWatch>((ref) {
//   return UserObjectWatch();
// });

// final _userObjectProvider = Provider<UserObjectWatch>((ref) {
//   return UserObjectWatch();
// });

// final _authStateProvider = StreamProvider<User?>((ref) {
//   Stream<User?> provider = ref.watch(authenticationWatchProvider).authStateChange;
//   return provider;
// });

// final authStateNotifierProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
//   ref.watch(authStateWatchProvider);
//   AuthNotifier authNotifier = AuthNotifier();
//   authNotifier.refresh();
//   return AuthNotifier();
// });

// final authNotifierProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
//   ref.watch(authenticationWatchProvider);
//   AuthNotifier authNotifier = AuthNotifier();
//   authNotifier.refresh();
//   return AuthNotifier();
// });

final authenticationProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier();
});

final authStreamProvider = StreamProvider<User?>((ref) {
  return ref.read(authenticationProvider).authStateChange;
});

final userStreamProvider = StreamProvider<User?>((ref) {
  return ref.read(authenticationProvider).userStateChange;
});

final userRolesProvider = StreamProvider<List<String>>((ref) {
  var streamController = StreamController<List<String>>();
  List<String> roles = [];
  ref.watch(userStreamProvider.future).then(
    ((User? user) async {
      Console.log(
        "ResolveRoles",
        scope: "fframeLog.userRolesProvider",
        level: LogLevel.fframe,
      );
      if (user != null) {
        IdTokenResult idTokenResult = await user.getIdTokenResult();

        Map<String, dynamic>? claims = idTokenResult.claims;

        if (claims != null && claims.containsKey("roles") == true) {
          Console.log(
            "Has roles formatted as ${claims["roles"].runtimeType}: ${claims["roles"].toString()}",
            scope: "fframeLog.userRolesProvider",
            level: LogLevel.fframe,
          );

          if ("${claims["roles"].runtimeType}".toLowerCase() ==
              "JSArray<dynamic>".toLowerCase()) {
            Console.log(
              "JSArray mode roles",
              scope: "fframeLog.userRolesProvider",
              level: LogLevel.fframe,
            );

            roles = List<String>.from(claims["roles"]);
          } else if (List<dynamic> == claims["roles"].runtimeType ||
              List<String> == claims["roles"].runtimeType) {
            Console.log(
              "standard mode roles",
              scope: "fframeLog.userRolesProvider",
              level: LogLevel.fframe,
            );
            Console.log(
              "${List<String>.from(claims["roles"].map((e) => e.toString()).toList())}",
              scope: "fframeLog.userRolesProvider",
              level: LogLevel.fframe,
            );
            roles = List<String>.from(
                claims["roles"].map((e) => e.toString()).toList());
          } else {
            Console.log(
              "map mode roles",
              scope: "fframeLog.userRolesProvider",
              level: LogLevel.fframe,
            );
            //Legacy mode... it's
            Console.log(
              "standard mode roles",
              scope: "fframeLog.userRolesProvider",
              level: LogLevel.fframe,
            );
            Map<String, dynamic>? rolesMap =
                Map<String, dynamic>.from(claims["roles"]);
            rolesMap.removeWhere((key, value) => value == false);
            roles = List<String>.from(rolesMap.keys);
          }

          roles = roles.map((role) => role.toLowerCase()).toList();
        }
        streamController.add(roles);
      }
    }),
  );
  return streamController.stream;
});

final userStateNotifier = ChangeNotifierProvider<AuthNotifier>((ref) {
  AuthNotifier authNotifier = AuthNotifier();

  // AsyncValue<List<String>> roles =
  var roles = ref.watch(userRolesProvider);

  ref.watch(userStreamProvider.future).then(((User? user) {
    authNotifier.user(user: user, roles: roles.value);
  })); //Will trigger then there is new data

  return authNotifier;
});

class AuthNotifier with ChangeNotifier {
  FFrameUser? _fFrameUser = FFrameUser();

  // For Authentication related functions you need an instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  This getter will be returning a Stream of User object.
  //  It will be used to check if the user is logged in or not.
  Stream<User?> get authStateChange => _auth.authStateChanges();
  Stream<User?> get userStateChange => _auth.userChanges();

  FFrameUser? get fFrameUser => _fFrameUser;
  user({required User? user, required List<String>? roles}) {
    if (user == null) {
      _fFrameUser = null;
      notifyListeners();
      return;
    }
    _fFrameUser = FFrameUser.fromFirebaseUser(firebaseUser: user);
    _fFrameUser?.roles = roles;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
