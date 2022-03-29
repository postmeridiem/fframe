part of fframe;

class AppUser extends StateNotifier {
  AppUser({required this.uid, this.displayName, this.email, this.photoUrl, required this.metaData, this.claims}) : super(null);

  final String? displayName;
  final String uid;
  final String? email;
  final String? photoUrl;
  final UserMetadata metaData;
  final Map<String, dynamic>? claims;

  factory AppUser.fromFirebaseUser(User firebaseUser, Map<String, dynamic>? claims) {
    return AppUser(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
      metaData: firebaseUser.metadata,
      claims: claims,
    );
  }
}
