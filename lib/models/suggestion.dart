import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Suggestion extends ChangeNotifier {
  Suggestion({this.id, this.name, this.active});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    print("reading <Suggestion>");

    Map<String, dynamic> json = snapshot.data()!;
    return Suggestion(
      id: snapshot.id,
      name: json['name']! as String,
      active: json['active'] == null ? true : json['active'] as bool,
    );
  }

  final String? id;
  String? name;
  String? icon;
  bool? active;

  Map<String, Object?> toFirestore() {
    print("writing <Suggestion>");
    return {'active': active, 'name': name};
  }
}
