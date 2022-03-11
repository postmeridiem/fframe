import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Client extends ChangeNotifier {
  Client({this.id, this.active, this.name, this.timezone});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    print("reading <Client>");

    Map<String, dynamic> json = snapshot.data()!;
    return Client(
      id: snapshot.id,
      active: json['active'] == null ? true : json['active'] as bool,
      name: json['name']! as String,
      timezone: json['timezone']! as String,
    );
  }

  final String? id;
  bool? active;
  String? name;
  String? timezone;

  Map<String, Object?> toFirestore() {
    print("writing <Client>");
    return {'active': active, 'name': name, 'timezone': timezone};
  }
}
