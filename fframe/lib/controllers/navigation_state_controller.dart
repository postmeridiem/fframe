import 'package:fframe/models/navigation_target.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SelectionState<T> {
  final QueryDocumentSnapshot<T>? queryDocumentSnapshot;
  final Map<String, String>? queryParams;
  final T? data;
  final String cardId;
  SelectionState({
    this.queryDocumentSnapshot,
    this.cardId = "",
    this.data,
    this.queryParams,
  });
}

class NavigationStateNotifier with ChangeNotifier {
  late String? _redirectState;
  late List<NavigationTarget> _navigationTargets = [];
  late List<String> _roles = [];
  late SelectionState _selectionState = SelectionState();

  int _currentIndex = 0;
  NavigationTarget? _currentTarget;
  Map<String, String>? _queryParams;
  ValueKey<String>? _pageKey;

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

  Map<String, String>? get queryParams => _queryParams;
  updateQueryParams(Map<String, String>? queryParams) async {
    _queryParams = queryParams;
    notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  ValueKey<String>? get pageKey => _pageKey;
  set pageKey(ValueKey<String>? pageKey) {
    _pageKey = pageKey;
  }

  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    _selectionState = SelectionState();
  }

  NavigationTarget? get currentTarget => _currentTarget;

  SelectionState get selectionState => _selectionState;
  set selectionState(SelectionState selectionState) {
    debugPrint("NavigationStateNotifier: new selectionState: ${selectionState.queryParams}");
    _selectionState = selectionState;
    notifyListeners();
  }
}
