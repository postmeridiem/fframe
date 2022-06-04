import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frouter/models/initial_config.dart';
import 'package:frouter/services/navigation_service.dart';

import '../models/models.dart';

class RouterPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    debugPrint("RouterPage.createRoute");
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => Consumer(builder: (context, ref, child) {
        debugPrint("Build FRouter");
        return FRouter(
          ref: ref,
          child: const RouterScreen(),
        );
      }),
    );
  }
}

///FRouter helps to navigate using navigationTargets and query string parameters
///UseFill methods: navigateTo(), updateQueryString()
class FRouter extends InheritedWidget {
  const FRouter({
    Key? key,
    required Widget child,
    required this.ref,
  }) : super(key: key, child: child);
  final WidgetRef ref;

  ///Path Only
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget);
  ///Path and update QS
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget, queryString: {"id": "cow"});
  ///Path and replace QS
  ///FRouter.of(context).navigateTo(navigationTarget: widget.navigationTarget, queryString: {"id": "cow"}, resetQueryString: true);
  navigateTo({required NavigationTarget navigationTarget, Map<String, String>? queryParameters, bool? resetQueryString = true}) {
    debugPrint("FRouter: navigate to ${navigationTarget.path} ${queryParameters == null ? "without" : "with"} queryString ${queryParameters?.toString() ?? ""}. Reset queryString: $resetQueryString");
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true) ? QueryState(queryParameters: queryParameters) : QueryState.mergeComponents(queryState, queryParameters);
    debugPrint(newQueryState.toString());

    TargetState targetState = TargetState.processRouteRequest(navigationTarget: navigationTarget);
    navigationNotifier.processRouteInformation(targetState: targetState, queryState: newQueryState);
  }

  ///Only QS (persist path and existing QS values)
  ///FRouter.of(context).updateQueryString(queryString: {"id": "cow"});
  ///Only QS (replace path and existing QS values)
  ///FRouter.of(context).updateQueryString(queryString: {"id": "cow"}, resetQueryString: true);
  updateQueryString({required Map<String, String> queryParameters, bool? resetQueryString = false}) {
    debugPrint("FRouter: update QueryString to ${queryParameters.toString()}");
    QueryState queryState = ref.read(queryStateProvider);

    QueryState newQueryState = (resetQueryString == true) ? QueryState(queryParameters: queryParameters) : QueryState.mergeComponents(queryState, queryParameters);
    debugPrint(newQueryState.toString());

    navigationNotifier.processRouteInformation(queryState: newQueryState);
    // navigationNotifier.uri = Uri.parse("${navigationNotifier.uri!.path}?${queryParameters.entries.map((queryStringEntry) => "${queryStringEntry.key}=${queryStringEntry.value}").join("&")}");
  }

  ///Notify a logout
  logout() {
    navigationNotifier.signOut();
  }

  ///Notify a login, optionally parse a list of current user roles
  login({List<String>? roles}) {
    navigationNotifier.signIn(roles: roles);
  }

  bool get isSignedIn {
    return navigationNotifier.isSignedIn;
  }

  NavigationConfig get navigationConfig {
    return navigationNotifier.navigationConfig;
  }

  static FRouter of(BuildContext context) {
    final FRouter? fRouter = context.dependOnInheritedWidgetOfExactType<FRouter>();
    assert(fRouter != null, 'No FRouter found in context');
    return fRouter!;
  }

  @override
  bool updateShouldNotify(FRouter oldWidget) {
    return true;
  }
}

class RouterScreen extends StatefulWidget {
  const RouterScreen({Key? key}) : super(key: key);

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      navigationNotifier.isBuilding = false;
    });
    debugPrint("Build RouterScreen");
    return Consumer(builder: (context, ref, child) {
      // NavigationNotifier navigationNotifier = ref.read(navigationProvider);
      return RouterConfig.instance.mainScreen;
    });
  }
}
