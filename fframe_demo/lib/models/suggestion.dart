import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Suggestion extends ChangeNotifier {
  Suggestion({this.id, this.name, this.active, this.icon, this.creationDate, this.createdBy});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    print("reading <Suggestion>");

    Map<String, dynamic> json = snapshot.data()!;
    return Suggestion(
      id: snapshot.id,
      name: json['name']! as String,
      active: json['active'] == null ? true : json['active'] as bool,
      icon: json['icon'] == '' ? 'ee93' : json['icon'] as String,
      creationDate: json['creationDate']! as Timestamp,
      createdBy: json['createdBy']! as String,
    );
  }

  final String? id;
  String? name;
  bool? active;
  String? icon;
  Timestamp? creationDate;
  String? createdBy;

  // TODO: integrate conversion to flutter icon into a model function

  //  Icon(
  //       IconData(
  //         // icon codes match with here https://api.flutter.dev/flutter/material/Icons-class.html#constants
  //         int.parse("0x${suggestion.icon}"),
  //         fontFamily: 'MaterialIcons',
  //       ),
  //     ),

  Map<String, Object?> toFirestore() {
    print("writing <Suggestion>");
    return {
      'active': active,
      'name': name,
      'icon': icon,
      'creationDate': creationDate,
      'createdBy': createdBy,
    };
  }
}
