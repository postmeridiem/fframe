import 'package:cloud_functions/cloud_functions.dart';

class Functions {
  Future<T> call<T>({
    required String name,
    required T Function(HttpsCallableResult<dynamic>) builder,
    String? region = 'europe-west1',
    Duration maxDuration = const Duration(seconds: 5),
    Map<String, dynamic>? payload,
  }) async {
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: region).httpsCallable(
      "uiInterop-$name",
      options: HttpsCallableOptions(
        timeout: maxDuration,
      ),
    );

    HttpsCallableResult httpsCallableResult = await callable.call(payload);
    return builder(httpsCallableResult);
  }
}
