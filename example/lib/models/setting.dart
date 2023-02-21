// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Setting extends ChangeNotifier {
  Setting({
    this.id,
    this.name,
    this.active,
    this.icon,
    this.creationDate,
    this.createdBy,
  });

  /// Setting class
  /// check [name] for the name
  ///
  /// this documentation is a lie
  ///
  /// =================
  ///
  /// [String] id - setting id
  ///
  /// [String] name - name of the setting
  ///
  /// [bool] active - is the setting active
  ///
  /// [String] icon - setting material icon id
  ///
  /// [Timestamp] creationDate - creation date of setting
  ///
  /// [String] createdBy - creator of the setting
  ///

  // fromFirestore<Setting>(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  factory Setting.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? snapshotOptions,
  ) {
    Map<String, dynamic> json = snapshot.data()!;
    Setting setting = Setting(
      id: snapshot.id,
      name: json['name']! as String,
      active: json['active'] == null ? true : json['active'] as bool,
      icon: json['icon'] == null ? 'question_mark' : json['icon'] as String,
      creationDate: json['creationDate'] != null
          ? json['creationDate'] as Timestamp
          : null,
      createdBy: json['createdBy'] != null ? json['createdBy'] as String : null,
    );

    return setting;
  }

  String? id;
  String? name;
  bool? active;
  String? icon;
  Timestamp? creationDate;
  String? createdBy;

  Map<String, Object?> toFirestore() {
    String updatedBy =
        FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous";

    final Map<String, Timestamp> changeHistory = {updatedBy: Timestamp.now()};

    return {
      "active": active,
      "name": name,
      "icon": icon,
      "creationDate": creationDate ?? Timestamp.now(),
      "createdBy": createdBy ??
          FirebaseAuth.instance.currentUser?.displayName ??
          "Anonymous",
      "changeHistory": FieldValue.arrayUnion([changeHistory]),
    };
  }
}
