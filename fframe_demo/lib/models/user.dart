import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  User({
    this.uid,
    this.displayName,
    this.active,
    this.email,
    this.photoURL,
    this.creationDate,
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? snapshotOptions) {
    debugPrint("reading <User>");

    Map<String, dynamic> json = snapshot.data()!;
    return User(
      uid: snapshot.id,
      displayName: json['displayName'] as String?,
      active: json['active'] == null ? true : json['active'] as bool,
      email: json['email'] as String?,
      photoURL: json["photoURL"] as String?,
      //creationDate: json['metadata.creationTime'] as Timestamp?,
      // creationDate: json['creationDate'] != null ? json['creationDate'] as Timestamp : Timestamp.now(),
    );
  }

  final String? uid;
  String? displayName;
  bool? active;
  String? email;
  String? photoURL;
  Timestamp? creationDate;

  Map<String, Object?> toFirestore() {
    debugPrint("writing <User>");
    return {
      // 'name': displayName,
      // 'creationDate': creationDate,
    };
  }
}
