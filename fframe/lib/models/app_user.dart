part of fframe;

class FFrameUser extends StateNotifier {
  FFrameUser({
    this.id,
    this.uid,
    this.displayName,
    this.email,
    this.photoURL,
    this.metaData,
    this.roles,
    this.firebaseUser,
  }) : super(null) {
    timeStamp = DateTime.now();
  }

  final String? id;
  final String? displayName;
  final String? uid;
  final String? email;
  final String? photoURL;
  final UserMetadata? metaData;
  late List<String>? roles;
  final User? firebaseUser;
  late DateTime? timeStamp;

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

  factory FFrameUser.fromFirebaseUser(
      {required User firebaseUser, List<String>? roles}) {
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
