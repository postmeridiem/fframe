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

  processRouteRequest({required NavigationTarget navigationTarget}) {
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
      return; // Early return to prevent accessing .first on empty list
    }

    //Check if this is a login path
    if (NavigationNotifier.instance.navigationConfig.signInConfig.signInTarget.path == uri.pathSegments.first) {
      navigationTarget = NavigationNotifier.instance.navigationConfig.signInConfig.signInTarget;
      return; // Handled — do not fall through to access-denied/error resolution.
    }
    //Check if this is an invite path
    if (NavigationNotifier.instance.navigationConfig.signInConfig.invitionTarget?.path == uri.pathSegments.first) {
      navigationTarget = NavigationNotifier.instance.navigationConfig.signInConfig.invitionTarget!;
      return; // Handled — do not fall through to access-denied/error resolution.
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
      } else {
        //The path is not among the user's accessible targets. Distinguish a
        //page that exists but is access-restricted from a genuinely unknown URL,
        //so the user gets a clear message instead of a blank/grey screen.
        bool existsButRestricted = FRouterConfig.instance.unfilteredNavigationConfig.navigationTargets.any(
          (NavigationTarget navigationTarget) => navigationTarget.path.removeLeadingSlash() == uri.pathSegments.first,
        );
        if (existsButRestricted) {
          Console.log(
            "Access denied to /${uri.pathSegments.first}; user lacks the required role(s).",
            scope: "fframeLog.TargetState.targetState",
            level: LogLevel.fframe,
            color: ConsoleColor.yellow,
          );
          navigationTarget = NavigationConfig.noAccessTarget;
        } else {
          Console.log("Unknown route /${uri.pathSegments.first}; routing to error page.", scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
          navigationTarget = NavigationNotifier.instance.navigationConfig.errorPage;
        }
      }
    } catch (e) {
      Console.log("ERROR: Routing to ${uri.toString()} failed: ${e.toString()}", scope: "fframeLog.TargetState.targetState", level: LogLevel.fframe);
    }
  }

  NavigationTarget get defaultRoute {
    List<NavigationTarget> navigationTargets = NavigationNotifier.instance.navigationConfig.navigationTargets;

    //Find the configured landing page among the targets the user can access.
    NavigationTarget? landingTarget;
    for (final NavigationTarget navigationTarget in navigationTargets) {
      if (navigationTarget.landingPage) {
        landingTarget = navigationTarget;
        break;
      }
    }

    if (landingTarget != null) {
      //Landing page found. Route to its first tab when tabbed, otherwise the
      //target itself (the latter previously fell through to the error page).
      if (landingTarget.navigationTabs?.isNotEmpty == true) {
        Console.log("Route to the first available tab", scope: "fframeLog.TargetState.defaultRoute", level: LogLevel.fframe);
        return landingTarget.navigationTabs!.first;
      }
      Console.log("DefaultRoute to ${landingTarget.title} at ${landingTarget.path}", scope: "fframeLog.TargetState.defaultRoute", level: LogLevel.fframe);
      return landingTarget;
    }

    //No landing page is accessible to this user.
    if (NavigationNotifier.instance.isSignedIn != true) {
      //Not signed in: send them to the sign-in page.
      return NavigationNotifier.instance.navigationConfig.signInConfig.signInTarget;
    }

    //Signed in but no resolvable landing page — either no target is flagged as
    //the landing page, or the user has no accessible routes at all. Surface a
    //clear message instead of a blank/grey screen, and do NOT silently route to
    //an unrelated target (which would undermine the access model).
    Console.log(
      "No accessible landing page for signed-in user. Showing fallback message.",
      scope: "fframeLog.TargetState.defaultRoute",
      level: LogLevel.dev,
      color: ConsoleColor.red,
    );
    return NavigationConfig.noLandingPageTarget;
  }

  @override
  String toString() {
    return "${navigationTarget.title} at path ${navigationTarget.path}";
  }
}
