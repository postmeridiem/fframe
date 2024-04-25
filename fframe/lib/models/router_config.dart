part of '../../fframe.dart';

class FRouterConfig {
  late NavigationConfig navigationConfig;
  late NavigationConfig filteredNavigationConfig;
  late Widget mainScreen;
  late RouterBuilder routerBuilder;
  late FFrameUser? user;

  static final FRouterConfig instance = FRouterConfig._internal();

  FRouterConfig._internal();

  factory FRouterConfig({
    required RouterBuilder routerBuilder,
    required NavigationConfig navigationConfig,
    required Widget mainScreen,
    required FFrameUser? user,
  }) {
    Console.log(
      "Init FRouterConfig for user: ${user?.email}",
      scope: "FRouterInit",
      level: LogLevel.fframe,
    );
    instance.user = user;

    navigationConfig.navigationTargets.forEach(
      ((NavigationTarget navigationTarget) {
        //Enforce leading slash
        if (!navigationTarget.path.startsWith("/")) {
          navigationTarget.path = "/${navigationTarget.path}";
        }

        Console.log(
          "${navigationTarget.title} => ${navigationTarget.path}",
          scope: "FRouterInit",
          level: LogLevel.fframe,
        );

        if (navigationTarget.navigationTabs != null && navigationTarget.navigationTabs!.isNotEmpty) {
          for (NavigationTab navigationTab in navigationTarget.navigationTabs!) {
            // ignore: unnecessary_null_comparison
            if (navigationTab.parentTarget == null) {
              navigationTab.parentTarget = navigationTarget;

              //Remove leading slash, as it is hard added during the string compose
              if (navigationTab.path.startsWith("/")) {
                navigationTab.path = navigationTab.path.substring(1);
              }

              navigationTab.path = "${navigationTab.parentTarget!.path}/${navigationTab.path}";
              Console.log(
                "${navigationTab.parentTarget!.title} => ${navigationTab.path}",
                scope: "FRouterInit",
                level: LogLevel.fframe,
              );
            } else {
              Console.log(
                "Already set: ${navigationTab.parentTarget!.title} => ${navigationTab.path}",
                scope: "FRouterInit",
                level: LogLevel.fframe,
              );
            }
          }
        } else if (!navigationTarget.path.startsWith("/")) {
          navigationTarget.path = "/${navigationTarget.path}";
        }
      }),
    );

    //Filter navigation config for a specific user
    if (user != null) {
      //Check routes for roles
      List<String> roles = user.roles;

      navigationConfig.navigationTargets.removeWhere(
        (NavigationTarget navigationTarget) {
          //Remove all routes which are not private
          if (navigationTarget.private == false) {
            return true;
          }

          //If the user does not have roles. return true
          if (roles.isEmpty) {
            return true;
          }

          //Role comparison
          Set<String> userRolesSet = roles.map((role) => role.toLowerCase()).toSet();
          List<String> targetRoles = navigationTarget.roles ?? [];

          //Check tabs first(if any)
          if (navigationTarget.navigationTabs != null) {
            //Get all roles allowed to see this tab.
            navigationTarget.navigationTabs!.where((NavigationTab navigationTab) => navigationTab.roles != null).forEach((NavigationTab navigationTab) {
              targetRoles.addAll(navigationTab.roles!);
            });

            navigationTarget.navigationTabs!.removeWhere((NavigationTab navigationTab) {
              //If the tab is not private, remove it
              if (navigationTab.private == false) {
                return true;
              }
              //If the tab has no role limitations, allow it
              if (navigationTab.roles == null) {
                return false;
              }

              //Check if the intersection contains a value. If so return false
              Set<String> targetRolesSet = navigationTab.roles!.map((role) => role.toLowerCase()).toSet();
              Set<String> interSection = userRolesSet.intersection(targetRolesSet);
              Console.log(
                "${navigationTarget.title}/${navigationTab.title} => ${interSection.isEmpty ? "no access" : "allow access"} (user: ${userRolesSet.toString()} path: ${targetRolesSet.toString()})",
                scope: "fframeLog.NavigationNotifier.instance.navigationRoutes.get",
                level: LogLevel.fframe,
              );
              return interSection.isEmpty;
            });
          }

          if (targetRoles.isEmpty) {
            //No role based limitations apply
            Console.log(
              "${navigationTarget.title} => allow",
              scope: "fframeLog.NavigationNotifier.instance.navigationRoutes.get",
              level: LogLevel.fframe,
            );
            return false;
          }

          //Check if the intersection contains a value. If so return false
          Set<String> targetRolesSet = targetRoles.map((role) => role.toLowerCase()).toSet();

          Set<String> interSection = userRolesSet.intersection(targetRolesSet);
          Console.log(
            "${navigationTarget.title} => ${interSection.isEmpty ? "no access" : "access"} (user: ${userRolesSet.toString()} path: ${targetRolesSet.toString()})",
            scope: "fframeLog.NavigationNotifier.instance.navigationRoutes.get",
            level: LogLevel.fframe,
          );
          return interSection.isEmpty;
        },
      );
    } else {
      //Not signed in. Keep public routes
      navigationConfig.navigationTargets.removeWhere((NavigationTarget navigationTarget) {
        //Remove all routes which are not public
        if (navigationTarget.public == false) {
          return true;
        }

        //Remove all tabs which are not public
        navigationTarget.navigationTabs?.removeWhere((NavigationTab navigationTab) {
          //If the target does not require roles. Return true
          return navigationTab.roles == null || navigationTab.roles!.isEmpty;
        });
        return navigationTarget.navigationTabs?.isEmpty ?? false;
      });
    }

    instance.mainScreen = mainScreen;
    instance.navigationConfig = navigationConfig;
    return instance;
  }
}

typedef RouterBuilder = Widget Function(
  BuildContext context,
  // Material data,
);
