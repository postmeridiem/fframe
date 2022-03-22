import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  User({this.id, this.name, this.creationDate});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    debugPrint("reading <User>");

    Map<String, dynamic> json = snapshot.data()!;
    return User(
      id: snapshot.id,
      name: json['name']! as String,
      creationDate: json['creationDate'] as Timestamp,
      // creationDate: json['creationDate'] != null ? json['creationDate'] as Timestamp : Timestamp.now(),
    );
  }

  final String? id;
  String? name;
  Timestamp? creationDate;

  Map<String, Object?> toFirestore() {
    debugPrint("writing <User>");
    return {'name': name, 'creationDate': creationDate};
  }
}
