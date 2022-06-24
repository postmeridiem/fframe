import 'package:fframe/fframe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final targetStateProvider = StateProvider<TargetState>((ref) {
  return TargetState.defaultRoute();
});

final queryStateProvider = StateProvider<QueryState>((ref) {
  return QueryState();
});
