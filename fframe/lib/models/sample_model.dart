import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SampleModel extends ChangeNotifier {
  String? string;
  double? number;
  bool? boolean;
  DateTime? datetime;
  SubModel? subModel;
  List<String>? stringList;
  List<double>? doubleList;
  List<bool>? boolList;
  List<DateTime>? dateTimeList;

  Map<String, String>? stringMap;
  Map<String, double>? doubleMap;
  Map<String, bool>? boolMap;
  Map<String, DateTime>? dateMap;

  Timestamp? timestamp;

  SampleModel({
    this.string,
    this.number,
    this.boolean,
    this.datetime,
    this.stringList,
    this.doubleList,
    this.subModel,
    this.dateTimeList,
    this.stringMap,
    this.doubleMap,
    this.boolMap,
    this.dateMap,
  });

  factory SampleModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? snapshotOptions,
  ) {
    Map<String, dynamic> json = snapshot.data()!;
    SampleModel sampleModel = SampleModel(
      string: json['string'] as String?,
      number: json['number'] as double?,
      boolean: json['boolean'] as bool?,
      datetime: json['string'] as DateTime?,
      subModel: SubModel.fromJson(json['subModel']),
    );

    return sampleModel;
  }
}

class SubModel {
  String? string;

  SubModel({
    this.string,
  });

  factory SubModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SubModel();
    }

    SubModel submodel = SubModel(
      string: json['string'] as String?,
    );
    return submodel;
  }
}
