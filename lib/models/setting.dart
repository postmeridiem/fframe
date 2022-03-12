import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Setting extends ChangeNotifier {
  Setting({this.id, this.name, this.active, this.icon});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    print("reading <Setting>");

    Map<String, dynamic> json = snapshot.data()!;
    return Setting(
      id: snapshot.id,
      name: json['name']! as String,
      active: json['active'] == null ? true : json['active'] as bool,
      icon: json['icon'] == '' ? 'ee93' : json['icon'] as String,
    );
  }

  final String? id;
  String? name;
  bool? active;
  String? icon;

  Map<String, Object?> toFirestore() {
    print("writing <Setting>");
    return {'active': active, 'name': name, 'icon': icon};
  }
}
