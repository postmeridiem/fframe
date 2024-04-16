// part of '../fframe.dart';

// class QueryState extends ChangeNotifier {
//   // Private static instance for the singleton
//   static final QueryState instance = QueryState._internal();

//   // Factory constructor to return the singleton instance
//   factory QueryState({Map<String, dynamic>? queryParameters}) {
//     // Initialize with queryParameters inside the factory constructor if needed
//     if (queryParameters != null) {
//       instance.queryParameters = queryParameters;
//       instance.notifyListeners();
//     }
//     return instance;
//   }

//   // Private constructor to prevent external instantiation
//   QueryState._internal();

//   // Your state properties
//   Map<String, dynamic>? queryParameters;
// // class QueryState extends ChangeNotifier {
// //   QueryState({this.queryParameters});

// //   final Map<String, String>? queryParameters;

//   factory QueryState.fromUri(Uri uri) {
//     return _fromUri(uri);
//   }

//   factory QueryState.fromString(String uriString) {
//     return _fromUri(Uri.parse(uriString));
//   }

//   static QueryState _fromUri(Uri uri) {
//     return QueryState(queryParameters: uri.queryParameters);
//   }

//   factory QueryState.mergeComponents(QueryState queryState, Map<String, String>? queryParameters) {
//     Map<String, String> newQueryParameters = {...queryState.queryParameters ?? {}, ...queryParameters ?? {}}; // Use spread operator for concise merging

//     Console.log(
//       "Merged parameters: ${newQueryParameters.toString()}",
//       scope: "fframeLog.QueryState.mergeComponents",
//       level: LogLevel.fframe,
//     );

//     return QueryState(queryParameters: newQueryParameters);
//   }

//   factory QueryState.defaultroute() {
//     return _defaultRoute();
//   }

//   static QueryState _defaultRoute() {
//     if (navigationNotifier.nextState.isNotEmpty) {
//       Console.log(
//         "Route to ${navigationNotifier.nextState.first.queryState.queryString}",
//         scope: "fframeLog.QueryState.defaultroute",
//         level: LogLevel.fframe,
//       );
//       return navigationNotifier.nextState.first.queryState;
//     }

//     return QueryState();
//   }

//   String get queryString {
//     return queryParameters?.entries.map((queryParameter) => "${queryParameter.key}=${queryParameter.value}").join("&") ?? "";
//   }

//   @override
//   String toString() {
//     return queryString;
//   }
// }
