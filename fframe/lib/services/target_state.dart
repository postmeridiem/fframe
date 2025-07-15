part of '../fframe.dart';

class TargetState extends ChangeNotifier {
  static final TargetState instance = TargetState._internal();
  TargetState._internal();

  factory TargetState({
    NavigationTarget? navigationTarget,
  }) {
    instance._navigationTarget = navigationTarget;
    return instance;
  }

  NavigationTarget? _navigationTarget;

  set navigationTarget(NavigationTarget navigationTarget) {
    _navigationTarget = navigationTarget;
    notifyListeners();
  }

  NavigationTarget get navigationTarget => _navigationTarget!;

  void processRouteRequest({required NavigationTarget navigationTarget}) {
    if (navigationTarget.navigationTabs != null && navigationTarget is! NavigationTab) {
      Console.log("Cannot route to a path which has tabs. Mandatory apply the first tab", scope: "fframeLog.TargetState.processRouteRequest", level: LogLevel.fframe);
      this.navigationTarget = navigationTarget.navigationTabs!.first;
      return;
    }
    this.navigationTarget = navigationTarget;
  }

  void fromUri(NavigationNotifier navigationNotifier, Uri uri) {
    if (uri.pathSegments.isEmpty && navigationNotifier.currentTarget == null) {
      //This either routes t or to the default route.

      navigationTarget = NavigationNotifier.instance.navigationConfig.navigationTargets.firstWhere(
        (NavigationTarget navigationTarget) => navigationTarget.path == "/",
        orElse: () {
          Console.log("Route to default route", scope: "fframeLog.TargetState.fromUri", level: LogLevel.fframe, color: ConsoleColor.white);
          return defaultRoute;
        },
      );
    }

    //Prevent naked URL
    if (uri.pathSegments.isEmpty) {
      navigationTarget = defaultRoute;
    }

    //Check if this is a login path
    if (NavigationNotifier.instance.navigationConfig.signInConfig.signInTarget.path == uri.pathSegments.first) {
      navigationTarget = NavigationNotifier.instance.navigationConfig.signInConfig.signInTarget;
      // return TargetState(navigationTarget: NavigationNotifier.instance.navigationConfig.signInConfig.signInTarget);
    }
    //Check if this is an invite path
    if (NavigationNotifier.instance.navigationConfig.signInConfig.invitionTarget?.path == uri.pathSegments.first) {
      navigationTarget = NavigationNotifier.instance.navigationConfig.signInConfig.invitionTarget!;
    }

    //Default to an error path

    // TargetState targetState = TargetState(navigationTarget: NavigationNotifier.instance.navigationConfig.errorPage);
    try {
      if (NavigationNotifier.instance.navigationConfig.navigationTargets.isEmpty) {
        Console.log("No routes have been defined", scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
        navigationTarget = NavigationNotifier.instance.navigationConfig.errorPage;
      }

      bool isValidPath = NavigationNotifier.instance.navigationConfig.navigationTargets.any(
        (NavigationTarget navigationTarget) => navigationTarget.path.removeLeadingSlash() == uri.pathSegments.first,
      );

      if (isValidPath) {
        NavigationTarget navigationTarget = NavigationNotifier.instance.navigationConfig.navigationTargets.firstWhere((NavigationTarget navigationTarget) {
          Console.log("${navigationTarget.path} == ${uri.pathSegments.first}", scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
          return navigationTarget.path.removeLeadingSlash() == uri.pathSegments.first;
        });

        if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty && uri.pathSegments.length > 1) {
          Console.log("Search for subroutes, get the corresponding tab config", scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
          String searchPath = "${navigationTarget.path}/${uri.pathSegments.last}";

          navigationTarget = navigationTarget.navigationTabs!.firstWhere(
            (NavigationTarget navigationTarget) => navigationTarget.path == searchPath,
            orElse: () {
              return NavigationNotifier.instance.navigationConfig.errorPage as NavigationTab;
            },
          );
          //Assign the selected tab to the targetState
          // targetState = TargetState(navigationTarget: navigationTab);
        } else if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty) {
          //Cannot route to a path which has tabs apply the first tab
          navigationTarget = navigationTarget.navigationTabs!.first;
        } else if (navigationTarget.contentPane != null) {
          //Assign the root target to the stargetState
          navigationTarget = navigationTarget;
        } else {
          Console.log("WARN: subtab requested, but configuration does not match", scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
        }
        Console.log("Routing to ${navigationTarget.path}", scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
        this.navigationTarget = navigationTarget;
      }
    } catch (e) {
      Console.log("ERROR: Routing to ${uri.toString()} failed: ${e.toString()}", scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
    }
  }

  NavigationTarget get defaultRoute {
    if (NavigationNotifier.instance.navigationConfig.navigationTargets.isEmpty && NavigationNotifier.instance.navigationConfig.navigationTargets.isNotEmpty) {
      //There are no unauthenticated routes

      // if (NavigationNotifier.instance.pendingAuth == false && NavigationNotifier.instance.isSignedIn != true) {
      if (NavigationNotifier.instance.isSignedIn != true) {
        //Assume there are no applicable routes within the access control. Route to the signin page or wait page
        return NavigationNotifier.instance.navigationConfig.signInConfig.signInTarget;
      }

      //We are still awaiting the auth state.... wait for it to be known
      //Store the current path
      return NavigationNotifier.instance.navigationConfig.waitPage;
    }
    List<NavigationTarget> navigationTargets = NavigationNotifier.instance.navigationConfig.navigationTargets;
    TargetState targetState = TargetState(
      navigationTarget: navigationTargets.firstWhere((NavigationTarget navigationTarget) => navigationTarget.landingPage, orElse: () {
        Console.log(
          "No public default route has been configured. Signed in: ${NavigationNotifier.instance.isSignedIn} ",
          scope: "fframeLog.TargetState.defaultRoute",
          level: LogLevel.fframe,
          color: ConsoleColor.yellow,
        );
        if (NavigationNotifier.instance.isSignedIn != true) {
          return NavigationNotifier.instance.navigationConfig.signInConfig.signInTarget;
        }
        Console.log("***** No public default route has been configured. Please update the navigation config. *****", scope: "fframeLog.TargetState.defaultRoute", level: LogLevel.dev, color: ConsoleColor.red);
        return NavigationNotifier.instance.navigationConfig.errorPage;
      }),
    );

    if (navigationTarget.navigationTabs?.isNotEmpty == true) {
      Console.log("Route to the first available tab", scope: "fframeLog.TargetState.defaultRoute", level: LogLevel.fframe);
      return targetState.navigationTarget.navigationTabs!.first;
    }

    // if (NavigationNotifier.instance.nextState.isNotEmpty) {
    //   Console.log("Route to ${NavigationNotifier.instance.nextState.first.targetState.navigationTarget.title} at ${NavigationNotifier.instance.nextState.first.targetState.navigationTarget.path}",
    //       scope: "fframeLog.TargetState.defaultRoute", level: LogLevel.fframe);
    //   navigationTarget = NavigationNotifier.instance.nextState.first.targetState;
    // }

    Console.log("DefaultRoute to ${targetState.navigationTarget.title} at ${targetState.navigationTarget.path}", scope: "fframeLog.TargetState.defaultRoute", level: LogLevel.fframe);
    return NavigationNotifier.instance.navigationConfig.errorPage;
  }

  @override
  String toString() {
    return "${navigationTarget.title} at path ${navigationTarget.path}";
  }
}
