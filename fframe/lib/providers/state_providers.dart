import 'package:fframe/fframe.dart';
// ignore: unnecessary_import
import 'package:flutter_riverpod/flutter_riverpod.dart';

final targetState = TargetState.defaultRoute();
final targetStateProvider = StateProvider<TargetState>((ref) {
  return targetState;
});

final queryStateProvider = StateProvider<QueryState>((ref) {
  return QueryState.instance;
});
