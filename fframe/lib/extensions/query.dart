import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension StartsWith<T> on Query<T> {
  Query<T> startsWith(String field, String searchTerm) {
    if (searchTerm.isEmpty) return this;
    final strFrontCode = searchTerm.substring(0, searchTerm.length - 1);
    final strEndCode = searchTerm.characters.last;
    final limit = strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
    return where(field, isGreaterThanOrEqualTo: searchTerm).where(field, isLessThan: limit);
  }
}
