part of fframe;

class QueryState {
  QueryState({this.queryParameters});

  final Map<String, String>? queryParameters;

  factory QueryState.fromUri(Uri uri) {
    return QueryState(queryParameters: uri.queryParameters);
  }

  factory QueryState.mergeComponents(
      QueryState queryState, Map<String, String>? queryParameters) {
    Map<String, String> newQueryParameters = {};
    newQueryParameters.addAll(queryState.queryParameters ?? {});
    newQueryParameters.addAll(queryParameters ?? {});
    Console.log(
      "Merged parameters: ${newQueryParameters.toString()}",
      scope: "fframeLog.QueryState.mergeComponents",
      level: LogLevel.fframe,
    );
    return QueryState(
        queryParameters: newQueryParameters); //, context: context);
  }

  factory QueryState.defaultroute() {
    if (navigationNotifier.nextState.isNotEmpty) {
      Console.log(
        "Route to ${navigationNotifier.nextState.first.queryState.queryString}",
        scope: "fframeLog.QueryState.defaultroute",
        level: LogLevel.fframe,
      );
      return navigationNotifier.nextState.first.queryState;
    }

    return QueryState();
  }

  String get queryString {
    return queryParameters?.entries
            .map((queryParameter) =>
                "${queryParameter.key}=${queryParameter.value}")
            .join("&") ??
        "";
  }

  @override
  String toString() {
    return queryString;
  }
}
