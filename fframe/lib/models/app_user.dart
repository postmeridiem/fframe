part of fframe;

class FFrameUser extends StateNotifier {
  FFrameUser({
    this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.metaData,
    this.roles,
  }) : super(null);

  final String? displayName;
  final String? uid;
  final String? email;
  final String? photoUrl;
  final UserMetadata? metaData;
  final List<String>? roles;

  factory FFrameUser.fromFirebaseUser({required User firebaseUser, List<String>? roles}) {
    return FFrameUser(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
      metaData: firebaseUser.metadata,
      roles: roles,
    );
  }
}
