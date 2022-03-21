import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Configuration extends ChangeNotifier {
  Configuration({this.id, this.name, this.active, this.icon, this.order});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    debugPrint("reading <Configuration>");

    Map<String, dynamic> json = snapshot.data()!;
    return Configuration(
      id: snapshot.id,
      name: json['name']! as String,
      icon: json['icon']! as String,
      active: json['active'] == null ? true : json['active'] as bool,
      order: json['order']! as int,
    );
  }

  final String? id;
  String? name;
  String? icon;
  bool? active;
  int? order;

  Map<String, Object?> toFirestore() {
    debugPrint("writing <Configuration>");
    return {'active': active, 'name': name, 'icon': icon, 'order': order};
  }
}
