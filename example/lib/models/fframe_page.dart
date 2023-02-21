// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FframePage extends ChangeNotifier {
  FframePage({
    this.id,
    this.active,
    this.public,
    this.name,
    this.body,
    this.icon,
    this.creationDate,
    this.createdBy,
  });

  // fromFirestore<Setting>(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  factory FframePage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? snapshotOptions,
  ) {
    Map<String, dynamic> json = snapshot.data()!;
    FframePage fframePage = FframePage(
      id: snapshot.id,
      active: json['active'] == null ? true : json['active'] as bool,
      public: json['public'] == null ? false : json['public'] as bool,
      name: json['name']! as String,
      body: json['body']! as String,
      icon: json['icon'] == null ? 'block' : json['icon'] as String,
      creationDate: json['creationDate'] != null
          ? json['creationDate'] as Timestamp
          : null,
      createdBy: json['createdBy'] != null ? json['createdBy'] as String : null,
    );

    return fframePage;
  }

  String? id;
  bool? active;
  bool? public;
  String? name;
  String? body;
  String? icon;
  Timestamp? creationDate;
  String? createdBy;

  Map<String, Object?> toFirestore() {
    String updatedBy =
        FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous";

    final Map<String, Timestamp> changeHistory = {updatedBy: Timestamp.now()};

    return {
      "active": active,
      "public": public,
      "name": name,
      "body": body,
      "icon": icon,
      "creationDate": creationDate ?? Timestamp.now(),
      "createdBy": createdBy ??
          FirebaseAuth.instance.currentUser?.displayName ??
          "Anonymous",
      "changeHistory": FieldValue.arrayUnion([changeHistory]),
    };
  }
}
