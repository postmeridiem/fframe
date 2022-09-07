// ignore_for_file: depend_on_referenced_packages

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
    this.saveCount = 0,
  });

  /// Suggestion class
  /// check [name] for the name
  ///
  /// this documentation is a lie
  ///
  /// =================
  ///
  /// [String] id - suggestion id
  ///
  /// [String] fieldTab1 - value
  ///
  /// [String] fieldTab2 - value
  ///
  /// [String] fieldTab3 - value
  ///
  /// [String] name - name of the suggestion
  ///
  /// [bool] active - is the suggestion active
  ///
  /// [String] icon - suggestion material icon id
  ///
  /// [Timestamp] creationDate - creation date of suggestion
  ///
  /// [String] createdBy - creator of the suggestion
  ///

  // fromFirestore<Suggestion>(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  factory Suggestion.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? snapshotOptions) {
    Map<String, dynamic> json = snapshot.data()!;
    Suggestion suggestion = Suggestion(
      id: snapshot.id,
      name: json['name']! as String,
      fieldTab1: json['fieldTab1'] as String?,
      fieldTab2: json['fieldTab2'] as String?,
      fieldTab3: json['fieldTab3'] as String?,
      active: json['active'] == null ? true : json['active'] as bool,
      icon: json['icon'] == null ? 'question_mark' : json['icon'] as String,
      creationDate: json['creationDate'] != null ? json['creationDate'] as Timestamp : null,
      createdBy: json['createdBy'] != null ? json['createdBy'] as String : null,
      saveCount: json['saveCount'] != null ? json['saveCount'] as double : 0,
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
  double saveCount = 0;

  Map<String, Object?> toFirestore() {
    String updatedBy = FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous";

    final Map<String, Timestamp> changeHistory = {updatedBy: Timestamp.now()};

    debugPrint("writing <Suggestion>");
    return {
      "active": active,
      "name": name,
      "icon": icon,
      "fieldTab1": fieldTab1,
      "fieldTab2": fieldTab2,
      "fieldTab3": fieldTab3,
      "creationDate": creationDate ?? Timestamp.now(),
      "createdBy": createdBy ?? FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
      "saveCount": saveCount,
      "changeHistory": FieldValue.arrayUnion([changeHistory]),
    };
  }
}
