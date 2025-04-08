part of '../../fframe.dart';

class FFrameUser extends ChangeNotifier {
  FFrameUser({
    this.id,
    this.uid,
    this.displayName,
    this.email,
    this.photoURL,
    this.metaData,
    roles,
    this.firebaseUser,
  }) : super() {
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
        scope: "FFrameUser.fromFirebaseUser",
        level: LogLevel.fframe,
      );

      for (var element in claims["roles"]) {
        if (element is String) {
          roles.add(element.toLowerCase());
        } else if (element is Map<String, dynamic>) {
          for (var entry in element.entries) {
            // Check if the value is a boolean and true, then add the key
            if (entry.value is bool && entry.value == true) {
              roles.add(entry.key.toLowerCase());
            }
          }
        } else if (element is List) {
          for (var item in element) {
            roles.add(item.toString().toLowerCase()); // Recursively process each item
          }
        } else if (element != null) {
          roles.add(element.toString().toLowerCase());
        }

        if (element is String) {
          roles.add(element);
        } else if (element != null) {
          // Convert non-null, non-string elements to strings in some way
          roles.add(element.toString());
        }
        // Optionally handle nulls or other types differently
      }

      roles = roles.map((role) => role.toLowerCase()).toSet().toList(); // Convert back to a list if you need a list;
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
