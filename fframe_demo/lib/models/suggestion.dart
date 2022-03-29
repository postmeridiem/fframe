import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Suggestion extends ChangeNotifier {
  Suggestion({
    this.id,
    this.fieldTab1,
    this.fieldTab2,
    this.fieldTab3,
    this.name,
    this.active,
    this.icon,
    this.creationDate,
    this.createdBy,
  });

  /// Suggestion class
  /// check [name] for the name
  ///
  /// this documentation is a lie
  // fromFirestore<Suggestion>(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  factory Suggestion.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? snapshotOptions) {
    debugPrint("reading <Suggestion>");

    Map<String, dynamic> json = snapshot.data()!;
    Suggestion suggestion = Suggestion(
      id: snapshot.id,
      name: json['name']! as String,
      fieldTab1: json['fieldTab1'] as String?,
      fieldTab2: json['fieldTab2'] as String?,
      fieldTab3: json['fieldTab3'] as String?,
      active: json['active'] == null ? true : json['active'] as bool,
      icon: json['icon'] == null ? 'ee93' : json['icon'] as String,
      creationDate: json['creationDate'] != null ? json['creationDate'] as Timestamp : null,
      createdBy: json['createdBy'] != null ? json['createdBy'] as String : null,
    );

    return suggestion;
  }

  String? id;
  String? name;
  bool? active;
  String? icon;
  String? fieldTab1;
  String? fieldTab2;
  String? fieldTab3;
  Timestamp? creationDate;
  String? createdBy;

  Map<String, Object?> toFirestore() {
    String updatedBy = FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous";

    final Map<String, Timestamp> changeHistory = {updatedBy: Timestamp.now()};

    debugPrint("writing <Suggestion>");
    return {
      "active": active,
      "name": name,
      "icon": icon,
      "creationDate": creationDate ?? Timestamp.now(),
      "createdBy": createdBy ?? FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
      "changeHistory": FieldValue.arrayUnion([changeHistory]),
    };
  }
}