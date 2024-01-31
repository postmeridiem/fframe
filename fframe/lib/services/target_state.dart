part of '../fframe.dart';

class TargetState {
  TargetState({
    required this.navigationTarget,
  });

  final NavigationTarget navigationTarget;

  factory TargetState.processRouteRequest(
      {required NavigationTarget navigationTarget}) {
    if (navigationTarget.navigationTabs != null &&
        navigationTarget is! NavigationTab) {
      Console.log(
          "Cannot route to a path which has tabs. Mandatory apply the first tab",
          scope: "fframeLog.TargetState.processRouteRequest",
          level: LogLevel.fframe);
      navigationTarget = navigationTarget.navigationTabs!.first;
    }
    return TargetState(navigationTarget: navigationTarget);
  }

  factory TargetState.fromUri(NavigationNotifier navigationNotifier, Uri uri) {
    if (uri.pathSegments.isEmpty && navigationNotifier.currentTarget == null) {
      //This either routes to a / route or to the default route.
      return TargetState(
        navigationTarget:
            navigationNotifier.navigationConfig.navigationTargets.firstWhere(
          (NavigationTarget navigationTarget) => navigationTarget.path == "/",
          orElse: ()  {
             return TargetState.defaultRoute().navigationTarget;
          },
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
        Console.log("No routes have been defined",
            scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
        return targetState;
      }

      bool isValidPath = navigationNotifier.navigationConfig.navigationTargets
          .any((NavigationTarget navigationTarget) =>
              navigationTarget.path == uri.pathSegments.first);
      if (isValidPath) {
        NavigationTarget navigationTarget = navigationNotifier
            .navigationConfig.navigationTargets
            .firstWhere((NavigationTarget navigationTarget) {
          Console.log("${navigationTarget.path} == ${uri.pathSegments.first}",
              scope: "fframeLog.TargetState.targetState",
              level: LogLevel.fframe);
          return navigationTarget.path == uri.pathSegments.first;
        });

        if (navigationTarget.navigationTabs != null &&
            navigationTarget.navigationTabs!.isNotEmpty &&
            uri.pathSegments.length > 1) {
          Console.log("Search for subroutes, get the corresponding tab config",
              scope: "fframeLog.TargetState.targetState",
              level: LogLevel.fframe);
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
          Console.log(
              "WARN: subtab requested, but configuration does not match",
              scope: "fframeLog.TargetState.targetState",
              level: LogLevel.fframe);
        }
      }
    } catch (e) {
      Console.log("ERROR: Routing to ${uri.toString()} failed: ${e.toString()}",
          scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
    }
    Console.log("Routing to ${targetState.navigationTarget.path}",
        scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
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
        Console.log(
            "***** No default route has been configured. Please update the navigation config. *****",
            scope: "fframeLog.TargetState.defaultRoute",
            level: LogLevel.fframe);
        return navigationNotifier.filteredNavigationConfig.errorPage;
      }),
    );

    if (targetState.navigationTarget.navigationTabs?.isNotEmpty == true) {
      Console.log("Route to the first available tab",
          scope: "fframeLog.TargetState.defaultRoute", level: LogLevel.fframe);
      targetState = TargetState(
          navigationTarget: targetState.navigationTarget.navigationTabs!.first);
    }

    if (navigationNotifier.nextState.isNotEmpty) {
      Console.log(
          "Route to ${navigationNotifier.nextState.first.targetState.navigationTarget.title} at ${navigationNotifier.nextState.first.targetState.navigationTarget.path}",
          scope: "fframeLog.TargetState.defaultRoute",
          level: LogLevel.fframe);
      return navigationNotifier.nextState.first.targetState;
    }

    Console.log(
        "DefaultRoute to ${targetState.navigationTarget.title} at ${targetState.navigationTarget.path}",
        scope: "fframeLog.TargetState.defaultRoute",
        level: LogLevel.fframe);
    return targetState;
  }

  @override
  String toString() {
    return "${navigationTarget.title} at path ${navigationTarget.path}";
  }
}
