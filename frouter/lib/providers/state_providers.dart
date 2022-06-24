import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frouter/services/query_state.dart';
import 'package:frouter/services/target_state.dart';

final targetStateProvider = StateProvider<TargetState>((ref) {
  return TargetState.defaultRoute();
});

final queryStateProvider = StateProvider<QueryState>((ref) {
  return QueryState();
});
