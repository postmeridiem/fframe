import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RunConfig extends ChangeNotifier {
  RunConfig({this.id, this.active, this.name, this.clientId});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    print("reading <RunConfig>");

    Map<String, dynamic> json = snapshot.data()!;
    return RunConfig(
      id: snapshot.id,
      active: json['active'] == null ? true : json['active'] as bool,
      name: json['name'] == null ? '' : json['name'] as String,
      clientId: json['clientId'] == null ? '' : json['clientId'] as String,
    );
  }

  final String? id;
  bool? active;
  String? name;
  String? clientId;

  Map<String, Object?> toFirestore() {
    print("writing <RunConfig>");
    return {'id': id, 'active': active, 'name': name, 'clientId': clientId};
  }
}
