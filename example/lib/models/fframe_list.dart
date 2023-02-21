// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FframeList extends ChangeNotifier {
  FframeList({
    this.id,
    this.name,
    this.type,
    this.options,
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
  /// [String] id - fframeList id
  ///
  /// [String] name - name of the fframeList
  ///
  /// [String] type - data type type of the fframeList
  ///
  /// [bool] active - is the fframeList active
  ///
  /// [String] icon - fframeList material icon id
  ///
  /// [Timestamp] creationDate - creation date of fframeList
  ///
  /// [String] createdBy - creator of the fframeList
  ///

  // fromFirestore<Setting>(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  factory FframeList.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? snapshotOptions,
  ) {
    Map<String, dynamic> json = snapshot.data()!;
    FframeList fframeList = FframeList(
      id: snapshot.id,
      name: json['name']! as String,
      type: json['type']! as String,
      options: json['options'] as List,
      icon: json['icon'] == null ? 'block' : json['icon'] as String,
      creationDate: json['creationDate'] != null
          ? json['creationDate'] as Timestamp
          : null,
      createdBy: json['createdBy'] != null ? json['createdBy'] as String : null,
    );

    return fframeList;
  }

  String? id;
  String? name;
  String? type;
  List? options;
  String? icon;
  Timestamp? creationDate;
  String? createdBy;

  Map<String, Object?> toFirestore() {
    String updatedBy =
        FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous";

    final Map<String, Timestamp> changeHistory = {updatedBy: Timestamp.now()};

    return {
      "name": name,
      "type": type,
      "options": options,
      "icon": icon,
      "creationDate": creationDate ?? Timestamp.now(),
      "createdBy": createdBy ??
          FirebaseAuth.instance.currentUser?.displayName ??
          "Anonymous",
      "changeHistory": FieldValue.arrayUnion([changeHistory]),
    };
  }
}
