// import 'package:fframe/components/auth/authentication.dart';
import 'package:fframe/controllers/appUserStateController.dart';
import 'package:fframe/controllers/navigationStateController.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationStateProvider = ChangeNotifierProvider<NavigationStateNotifier>((ref) {
  return NavigationStateNotifier();
});

final userStateNotifierProvider = StateNotifierProvider<UserStateNotifier, UserState>(
  (ref) {
    return UserStateNotifier();
  },
);
