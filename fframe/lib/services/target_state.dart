part of fframe;

class TargetState {
  TargetState({
    required this.navigationTarget,
  });

  final NavigationTarget navigationTarget;

  factory TargetState.processRouteRequest(
      {required NavigationTarget navigationTarget}) {
    if (navigationTarget.navigationTabs != null &&
        navigationTarget is! NavigationTab) {
      debugPrint(
          "fframeLog.TargetState.processRouteRequest: Cannot route to a path which has tabs. Mandatory apply the first tab");
      navigationTarget = navigationTarget.navigationTabs!.first;
    }
    return TargetState(navigationTarget: navigationTarget);
  }

  factory TargetState.fromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      //This either routes to a / route or to the default route.
      return TargetState(
        navigationTarget:
            navigationNotifier.navigationConfig.navigationTargets.firstWhere(
          (NavigationTarget navigationTarget) => navigationTarget.path == "/",
          orElse: () => TargetState.defaultRoute().navigationTarget,
        ),
      );
    }

    //Check if this is a login path
    if (navigationNotifier.navigationConfig.signInConfig.signInTarget.path ==
        uri.pathSegments.first) {
      return TargetState(
          navigationTarget:
              navigationNotifier.navigationConfig.signInConfig.signInTarget);
    }
    //Check if this is an invite path
    if (navigationNotifier.navigationConfig.signInConfig.invitionTarget?.path ==
        uri.pathSegments.first) {
      return TargetState(
          navigationTarget:
              navigationNotifier.navigationConfig.signInConfig.invitionTarget!);
    }

    //Default to an error path

    TargetState targetState = TargetState(
        navigationTarget: navigationNotifier.navigationConfig.errorPage);
    try {
      if (navigationNotifier.navigationConfig.navigationTargets.isEmpty) {
        debugPrint(
            "fframeLog.TargetState.targetState: No routes have been defined");
        return targetState;
      }

      bool isValidPath = navigationNotifier.navigationConfig.navigationTargets
          .any((NavigationTarget navigationTarget) =>
              navigationTarget.path == uri.pathSegments.first);
      if (isValidPath) {
        NavigationTarget navigationTarget = navigationNotifier
            .navigationConfig.navigationTargets
            .firstWhere((NavigationTarget navigationTarget) {
          debugPrint(
              "fframeLog.TargetState.targetState: ${navigationTarget.path} == ${uri.pathSegments.first}");
          return navigationTarget.path == uri.pathSegments.first;
        });

        if (navigationTarget.navigationTabs != null &&
            navigationTarget.navigationTabs!.isNotEmpty &&
            uri.pathSegments.length > 1) {
          debugPrint(
              "fframeLog.TargetState.targetState: Search for subroutes, get the corresponding tab config.");
          String searchPath =
              "${navigationTarget.path}/${uri.pathSegments.last}";

          NavigationTab navigationTab =
              navigationTarget.navigationTabs!.firstWhere(
            (NavigationTarget navigationTarget) =>
                navigationTarget.path == searchPath,
            orElse: () {
              return navigationNotifier.navigationConfig.errorPage
                  as NavigationTab;
            },
          );
          //Assign the selected tab to the targetState
          targetState = TargetState(navigationTarget: navigationTab);
        } else if (targetState.navigationTarget.navigationTabs != null &&
            navigationTarget.navigationTabs!.isNotEmpty) {
          //Cannot route to a path which has tabs apply the first tab
          targetState = TargetState(
              navigationTarget:
                  targetState.navigationTarget.navigationTabs!.first);
        } else if (targetState.navigationTarget.contentPane != null) {
          //Assign the root target to the stargetState
          targetState = TargetState(navigationTarget: navigationTarget);
        } else {
          debugPrint(
              "fframeLog.TargetState.targetState: WARN: subtab requested, but configuration does not match.");
        }
      }
    } catch (e) {
      debugPrint(
          "fframeLog.TargetState.targetState: ERROR: Routing to ${uri.toString()} failed: ${e.toString()}");
    }
    debugPrint(
        "fframeLog.TargetState.targetState: Routing to ${targetState.navigationTarget.path}");
    return targetState;
  }

  factory TargetState.defaultRoute() {
    if (navigationNotifier.filteredNavigationConfig.navigationTargets.isEmpty &&
        navigationNotifier.navigationConfig.navigationTargets.isNotEmpty) {
      //There are no unauthenticated routes

      if (navigationNotifier.pendingAuth == false &&
          navigationNotifier.isSignedIn != true) {
        // if (navigationNotifier.isSignedIn != true) {
        //Assume there are no applicable routes within the access control. Route to the signin page or wait page
        return TargetState(
          navigationTarget: navigationNotifier
              .filteredNavigationConfig.signInConfig.signInTarget,
        );
      }

      //We are still awaiting the auth state.... wait for it to be known
      //Store the current path
      return TargetState(
        navigationTarget: navigationNotifier.filteredNavigationConfig.waitPage,
      );
    }
    List<NavigationTarget> navigationTargets =
        navigationNotifier.filteredNavigationConfig.navigationTargets;
    TargetState targetState = TargetState(
      navigationTarget: navigationTargets.firstWhere(
          (NavigationTarget navigationTarget) => navigationTarget.landingPage,
          orElse: () {
        debugPrint(
            "fframeLog.TargetState.defaultRoute: ***** No default route has been configured. Please update the navigation config. *****");
        return navigationNotifier.filteredNavigationConfig.errorPage;
      }),
    );

    if (targetState.navigationTarget.navigationTabs?.isNotEmpty == true) {
      debugPrint(
          "fframeLog.TargetState.defaultRoute: Route to the first available tab");
      targetState = TargetState(
          navigationTarget: targetState.navigationTarget.navigationTabs!.first);
    }

    if (navigationNotifier.nextState.isNotEmpty) {
      debugPrint(
          "fframeLog.TargetState.defaultRoute: Route to ${navigationNotifier.nextState.first.targetState.navigationTarget.title} at ${navigationNotifier.nextState.first.targetState.navigationTarget.path}");
      return navigationNotifier.nextState.first.targetState;
    }

    debugPrint(
        "fframeLog.TargetState.defaultRoute: DefaultRoute to ${targetState.navigationTarget.title} at ${targetState.navigationTarget.path}");
    return targetState;
  }

  @override
  String toString() {
    return "${navigationTarget.title} at path ${navigationTarget.path}";
  }
}
