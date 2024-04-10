part of '../../fframe.dart';

class FFrameUser extends StateNotifier {
  FFrameUser({
    this.id,
    this.uid,
    this.displayName,
    this.email,
    this.photoURL,
    this.metaData,
    roles,
    this.firebaseUser,
  }) : super(null) {
    timeStamp = DateTime.now();
    _roles = roles;
  }

  final String? id;
  final String? displayName;
  final String? uid;
  final String? email;
  final String? photoURL;
  final UserMetadata? metaData;
  List<String>? _roles;
  final User? firebaseUser;
  late DateTime? timeStamp;

  List<String> get roles => _roles ?? [];

  factory FFrameUser.fromFirestore({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? snapshotOptions,
  }) {
    Map<String, dynamic> json = snapshot.data()!;
    FFrameUser user = FFrameUser(
      id: snapshot.id,
      displayName: json['displayName'] ?? "",
      uid: json['uid'] ?? "",
      email: json['email'] ?? "",
      photoURL: json['photoURL'] ?? "",
    );

    return user;
  }

  bool hasRole(String role) {
    return _roles!.contains(role.toLowerCase());
  }

  factory FFrameUser.fromFirebaseUser({required User firebaseUser, required IdTokenResult idTokenResult}) {
    List<String> roles = [];

    Map<String, dynamic>? claims = idTokenResult.claims;
    if (claims != null && claims.containsKey("roles") == true) {
      Console.log(
        "Has roles in ${claims["roles"].runtimeType} as ${claims["roles"].toString()}",
        scope: "FFrameUser.fromFirebaseUserr",
        level: LogLevel.fframe,
      );

      if ("${claims["roles"].runtimeType}".toLowerCase() == "JSArray<dynamic>".toLowerCase()) {
        roles = List<String>.from(claims["roles"]);
      } else if (List<dynamic> == claims["roles"].runtimeType || List<String> == claims["roles"].runtimeType) {
        roles = List<String>.from(claims["roles"]);
      } else {
        //Legacy mode... it's a map..
        Map<String, dynamic>? rolesMap = Map<String, dynamic>.from(claims["roles"]);
        rolesMap.removeWhere((key, value) => value == false);
        roles = List<String>.from(rolesMap.keys);
      }

      roles = roles.map((role) => role.toLowerCase()).toList();
    }

    return FFrameUser(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      photoURL: firebaseUser.photoURL,
      metaData: firebaseUser.metadata,
      roles: roles,
      firebaseUser: firebaseUser,
    );
  }
}
