import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  User({this.id, this.name});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    print("reading <User>");

    Map<String, dynamic> json = snapshot.data()!;
    return User(
      id: snapshot.id,
      name: json['name']! as String,
    );
  }

  final String? id;
  String? name;

  Map<String, Object?> toFirestore() {
    print("writing <User>");
    return {'name': name};
  }
}
