part of fframe;

class FFrameUser extends StateNotifier {
  FFrameUser({
    this.id,
    this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
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
  final String? photoUrl;
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
      displayName: json['uid']! as String,
      uid: json['uid']! as String,
      email: json['email']! as String,
      photoUrl: json['photoUrl']! as String,
    );

    return user;
  }

  factory FFrameUser.fromFirebaseUser(
      {required User firebaseUser, List<String>? roles}) {
    return FFrameUser(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
      metaData: firebaseUser.metadata,
      roles: roles,
      firebaseUser: firebaseUser,
    );
  }
}
