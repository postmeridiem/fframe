import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class NavigationState {
  late String? _redirectState;
  late List<NavigationTarget> _navigationTargets = [];
  late List<String> _roles = [];

  int _currentIndex = 0;
  NavigationTarget? _currentTarget;
  ValueKey<String>? pageKey;

  //Setters and getters to preserve toe initial state (before signing amd apply it after initial load)
  set redirectState(String? redirectState) {
    debugPrint("Registered redirect to $redirectState");
    _redirectState = redirectState;
  }

  String? get redirectState {
    String? redirectState = _redirectState;
    return redirectState;
  }

  //Setters and getters to manage the currently possible NavigationTargets
  List<NavigationTarget> get navigationTargets {
    List<NavigationTarget> navigationTargets = _navigationTargets;
    navigationTargets.removeWhere((NavigationTarget navigationTarget) {
      if (navigationTarget.roles != null) {
        //Check the roles for this user
        if (_roles.isEmpty) return false; //Roles cannot match if user does not have any

        //Create comparible sets
        var userRoles = _roles.toSet();
        var navigationRoles = navigationTarget.roles!.toSet();

        var matchingRoles = navigationRoles.intersection(userRoles);
        return matchingRoles.isEmpty;
      }
      //No limitations defined, allow this item.
      return false;
    });
    return navigationTargets;
  }

  set navigationTargets(List<NavigationTarget> navigationTargets) => _navigationTargets = navigationTargets;

  //Setters afor the current user role(s)
  set roles(List<String> roles) => _roles = roles;

  //Getter for the navigation rail
  List<NavigationTarget>? get selectableTargets {
    List<NavigationTarget> navigationTargets = _navigationTargets.where((navigationTarget) => navigationTarget.navigationRailDestination != null).toList();
    navigationTargets.removeWhere((NavigationTarget navigationTarget) {
      // if (_claims.roles.isEmpty())

      if (navigationTarget.roles != null) {
        //Check the roles for this user
        if (_roles.isEmpty) return false; //Roles cannot match if user does not have any

        //Create comparible sets
        var userRoles = _roles.toSet();
        var navigationRoles = navigationTarget.roles!.toSet();

        var matchingRoles = navigationRoles.intersection(userRoles);
        return matchingRoles.isEmpty;
      }
      //No limitations defined, allow this item.
      return false;
    });
    return navigationTargets;
  }

  NavigationTarget? get currentTarget => _currentTarget;
}

class NavigationStateNotifier with ChangeNotifier {
  late NavigationState _navigationState = NavigationState();
  // ValueKey<String>? pageKey;

  // // ignore: unnecessary_getters_setters
  ValueKey<String>? get pageKey => _navigationState.pageKey;
  set pageKey(ValueKey<String>? pageKey) {
    _navigationState.pageKey = pageKey;
    notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  int get currentIndex => _navigationState._currentIndex;
  set currentIndex(int index) {
    _navigationState._currentIndex = index;
    notifyListeners();
  }

  NavigationState get state => _navigationState;
  set state(NavigationState navigationState) {
    debugPrint("NavigationStateNotifier: new navigationState: ${navigationState.pageKey}");
    _navigationState = navigationState;
    notifyListeners();
  }
}
