import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AppUser extends ChangeNotifier {
  AppUser({
    this.uid,
    this.displayName,
    this.active,
    this.customClaims,
    this.email,
    this.photoURL,
    this.creationDate,
  });

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? snapshotOptions) {
    Map<String, dynamic> json = snapshot.data()!;
    return AppUser(
      uid: snapshot.id,
      displayName: json['displayName'] as String?,
      active: json['active'] == null ? true : json['active'] as bool,
      customClaims: json['customClaims'],
      email: json['email'] as String?,
      photoURL: json["photoURL"] as String?,
      //creationDate: json['metadata.creationTime'] as Timestamp?,
      // creationDate: json['creationDate'] != null ? json['creationDate'] as Timestamp : Timestamp.now(),
    );
  }

  final String? uid;
  String? displayName;
  bool? active;
  Map<String, dynamic>? customClaims;
  String? email;
  String? photoURL;
  Timestamp? creationDate;

  Map<String, Object?> toFirestore() {
    debugPrint("writing <AppUser>");
    return {
      // 'name': displayName,
      // 'creationDate': creationDate,
    };
  }
}
