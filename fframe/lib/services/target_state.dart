part of fframe;

class TargetState {
  TargetState({
    required this.navigationTarget,
  });

  final NavigationTarget navigationTarget;

  factory TargetState.processRouteRequest({required NavigationTarget navigationTarget}) {
    if (navigationTarget.navigationTabs != null) {
      debugPrint("Cannot route to a path which has tabs. Mandatory apply the first tab");
      navigationTarget = navigationTarget.navigationTabs!.first;
    }
    return TargetState(navigationTarget: navigationTarget);
  }

  factory TargetState.fromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      //This either routes to a / route or to the default route.
      return TargetState(
        navigationTarget: navigationNotifier.navigationConfig.navigationTargets.firstWhere(
          (NavigationTarget navigationTarget) => navigationTarget.path == "/",
          orElse: () => TargetState.defaultRoute().navigationTarget,
        ),
      );
    }

    //Check if this is a login path
    if (navigationNotifier.navigationConfig.signInConfig.signInTarget.path == uri.pathSegments.first) {
      return TargetState(navigationTarget: navigationNotifier.navigationConfig.signInConfig.signInTarget);
    }
    //Check if this is an invite path
    if (navigationNotifier.navigationConfig.signInConfig.invitionTarget?.path == uri.pathSegments.first) {
      return TargetState(navigationTarget: navigationNotifier.navigationConfig.signInConfig.invitionTarget!);
    }

    //Check if this is part of the config
    TargetState targetState = TargetState(
      navigationTarget: navigationNotifier.navigationConfig.navigationTargets.firstWhere(
        (NavigationTarget navigationTarget) => navigationTarget.path == uri.pathSegments.first,
        orElse: () {
          debugPrint("No route found to ${uri.pathSegments.first}. Please update the navigation config.");
          return navigationNotifier.navigationConfig.errorPage;
        },
      ),
    );

    if (uri.pathSegments.length > 1) {
      debugPrint("Search for subroutes. If not found..... error page");
      if (targetState.navigationTarget.navigationTabs == null || targetState.navigationTarget.navigationTabs!.isEmpty) {
        return TargetState(navigationTarget: navigationNotifier.navigationConfig.errorPage);
      }

      try {
        NavigationTab navigationTab = targetState.navigationTarget.navigationTabs!.firstWhere((NavigationTarget navigationTarget) => navigationTarget.path == uri.pathSegments.last);
        targetState = TargetState(navigationTarget: navigationTab);
      } catch (e) {
        TargetState(navigationTarget: navigationNotifier.navigationConfig.errorPage);
      }
    } else if (targetState.navigationTarget.navigationTabs != null) {
      //Cannot route to a path which has tabs. Mandatory apply the first tab
      targetState = TargetState(navigationTarget: targetState.navigationTarget.navigationTabs!.first);
    }

    return targetState;
  }

  factory TargetState.defaultRoute() {
    if (navigationNotifier.navigationConfig.navigationTargets.isEmpty && RouterConfig.instance.navigationConfig.navigationTargets.isNotEmpty) {
      //There are no unauthenticated routes

      // if (navigationNotifier.pendingAuth == false && navigationNotifier.isSignedIn != true) {
      if (navigationNotifier.isSignedIn != true) {
        //Assume there are no applicable routes within the access control. Route to the signin page or wait page

        //Store the current path
        return TargetState(
          navigationTarget: navigationNotifier.navigationConfig.signInConfig.signInTarget,
        );
      }

      //We are still awaiting the auth state.... wait for it to be known
      //Store the current path
      return TargetState(
        navigationTarget: navigationNotifier.navigationConfig.waitPage,
      );
    }
    TargetState targetState = TargetState(
      navigationTarget: navigationNotifier.navigationConfig.navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.landingPage, orElse: () {
        debugPrint("***** No default route has been configured. Please update the navigation config. *****");
        return navigationNotifier.navigationConfig.errorPage;
      }),
    );

    if (targetState.navigationTarget.navigationTabs?.isNotEmpty == true) {
      debugPrint("Route to the first available tab");
      targetState = TargetState(navigationTarget: targetState.navigationTarget.navigationTabs!.first);
    }

    debugPrint("DefaultRoute to ${targetState.navigationTarget.title} at ${targetState.navigationTarget.path}");
    return targetState;
  }

  @override
  String toString() {
    return "${navigationTarget.title} at path ${navigationTarget.path}";
  }
}
