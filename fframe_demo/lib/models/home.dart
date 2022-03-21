import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Home extends ChangeNotifier {
  Home({this.id, this.name, this.active, this.creationDate, this.icon, this.body});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    debugPrint("reading <Home>");

    Map<String, dynamic> json = snapshot.data()!;
    return Home(
      id: snapshot.id,
      name: json['name']! as String,
      active: json['active'] == null ? true : json['active'] as bool,
      icon: json['icon'] == '' ? 'ee93' : json['icon'] as String,
      creationDate: json['creationDate']! as Timestamp,
      body: json['body']! as String,
    );
  }

  final String? id;
  String? name;
  bool? active;
  String? icon;
  Timestamp? creationDate;
  String? createdBy;
  String? body;

  Map<String, Object?> toFirestore() {
    debugPrint("writing <Home>");
    return {
      'active': active,
      'name': name,
      'icon': icon,
      'creationDate': creationDate,
    };
  }
}
