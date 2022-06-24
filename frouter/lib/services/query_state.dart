import 'package:flutter/foundation.dart';

class QueryState {
  QueryState({this.queryParameters});

  final Map<String, String>? queryParameters;

  factory QueryState.fromUri(Uri uri) {
    return QueryState(queryParameters: uri.queryParameters);
  }

  factory QueryState.mergeComponents(QueryState queryState, Map<String, String>? queryParameters) {
    Map<String, String> newQueryParameters = {};
    newQueryParameters.addAll(queryState.queryParameters ?? {});
    newQueryParameters.addAll(queryParameters ?? {});
    debugPrint("Merged parameters: ${newQueryParameters.toString()}");
    return QueryState(queryParameters: newQueryParameters); //, context: context);
  }

  String get queryString {
    return queryParameters?.entries.map((queryParameter) => "${queryParameter.key}=${queryParameter.value}").join("&") ?? "";
  }

  @override
  String toString() {
    return queryString;
  }
}
