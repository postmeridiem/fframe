import 'package:fframe/controllers/app_user_state_controller.dart';
// import 'package:fframe/controllers/navigation_state_controller.dart';
// import 'package:fframe/controllers/selection_state_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final navigationStateProvider = ChangeNotifierProvider<NavigationStateNotifier>((ref) {
//   return NavigationStateNotifier();
// });

// final selectionStateProvider = ChangeNotifierProvider<SelectionStateNotifier>((ref) {
//   // NavigationState navigationState = ref.watch(navigationStateProvider).state;
//   SelectionStateNotifier selectionStateNotifier = SelectionStateNotifier();
//   // String? path;
//   // if (path != navigationState.currentTarget?.path) {
//   //   path = navigationState.currentTarget?.path;
//   //   selectionStateNotifier.state = SelectionState(docId: null);
//   // }

//   return selectionStateNotifier;
// });

final userStateNotifierProvider = StateNotifierProvider<UserStateNotifier, UserState>(
  (ref) {
    return UserStateNotifier();
  },
);
