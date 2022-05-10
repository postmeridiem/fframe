part of fframe;

class AppUser extends StateNotifier {
  AppUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    required this.metaData,
    this.roles,
  }) : super(null);

  final String? displayName;
  final String uid;
  final String? email;
  final String? photoUrl;
  final UserMetadata metaData;
  final List<String>? roles;

  factory AppUser.fromFirebaseUser({required User firebaseUser, List<String>? roles}) {
    return AppUser(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
      metaData: firebaseUser.metadata,
      roles: roles,
    );
  }
}
