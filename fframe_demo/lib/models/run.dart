import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Run extends ChangeNotifier {
  Run({this.id, this.active, this.clientId, this.createdDate, this.runId, this.runconfigId, this.stepCurrent});

  fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    debugPrint("reading <Run>");

    Map<String, dynamic> json = snapshot.data()!;
    return Run(
        id: snapshot.id,
        active: json['active'] == null ? false : json['active'] as bool,
        clientId: json['clientId']! as String,
        createdDate: json['createdDate']! as String,
        runId: json['runId']! as String,
        runconfigId: json['runconfigId']! as String,
        stepCurrent: json['stepCurrent']! as String);
  }

  final String? id;
  final bool? active;
  final String? clientId;
  final String? createdDate;
  final String? runId;
  final String? runconfigId;
  final String? stepCurrent;

  Map<String, Object?> toFirestore() {
    debugPrint("writing <Run>");
    return {'active': active, 'clientId': clientId, 'createdDate': createdDate, 'runconfigId': runconfigId, 'stepCurrent': stepCurrent};
  }
}
