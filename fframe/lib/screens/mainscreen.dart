import 'package:fframe/controllers/navigation_state_controller.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/providers/global_providers.dart';
import 'package:fframe/screens/errorscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clipboard/clipboard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatelessWidget {
  final String appTitle;
  final Widget child;
  final GoRouterState state;
  final List<NavigationTarget> navigationTargets;
  final ThemeData darkMode;
  final ThemeData lightMode;
  const MainScreen({
    Key? key,
    required this.appTitle,
    required this.child,
    required this.state,
    required this.navigationTargets,
    required this.darkMode,
    required this.lightMode,
  }) : super(key: key);

  ActiveTarget getActiveTarget() {
    List<String> subloc = state.subloc.split('/');
    subloc.removeWhere((String element) => element == ''); //Clean out any empty strings
    List<NavigationTarget> _navigationTargets = List<NavigationTarget>.from(navigationTargets);

    //Remove any targets which are not currently loaded....
    _navigationTargets.removeWhere((NavigationTarget navigationTarget) => navigationTarget.path != subloc.first);
    if (_navigationTargets.isEmpty) {
      debugPrint("_navigationTargets should not be empty.");
      for (var navigationTarget in _navigationTargets) {
        debugPrint(" ${navigationTarget.path != subloc.first} => ${navigationTarget.path}");
      }
      return ActiveTarget(
        currentTarget: NavigationTarget(
          title: "Error",
          path: "/error",
          contentPane: ErrorScreen(
            error: Exception("Navigation target could not be located or is not accesible for your account."),
          ),
        ),
      );
    }

    if (_navigationTargets.length == 1 && subloc.length == 1) return ActiveTarget(currentTarget: _navigationTargets.first);
    //This is the only applicable target

    //Research the tabs
    List<NavigationTarget> _parentNavigationTargets = List<NavigationTarget>.from(_navigationTargets.first.navigationTabs!);
    _parentNavigationTargets.removeWhere((NavigationTarget navigationTarget) => navigationTarget.path != subloc.last);
    return ActiveTarget(currentTarget: _parentNavigationTargets.first, parentTarget: _navigationTargets.first);
  }

  String _pageTitle(ActiveTarget activeTarget) {
    return (activeTarget.parentTarget == null) ? activeTarget.currentTarget.title : "${activeTarget.parentTarget!.title} - ${activeTarget.currentTarget.title}";
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build mainScreen ${state.location} ${state.queryParams.toString()}");
    ActiveTarget _activeTargets = getActiveTarget();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    String pageTitle = _pageTitle(_activeTargets);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Consumer(
            builder: (context, ref, _) {
              String subTitle = ref.watch(navigationStateProvider).currentTarget?.title != null ? ":: ${ref.watch(navigationStateProvider).currentTarget!.title}" : "";
              return (subTitle.isEmpty) ? Text(pageTitle) : Text("$pageTitle - $subTitle");
            },
          ),
          actions: [
            const BarButtonShare(),
            const BarButtonDuplicate(),
            const BarButtonFeedback(),
            if (FirebaseAuth.instance.currentUser != null) const BarButtonProfile(),
          ],
        ),
        body: MainBody(
          key: key,
          activeTarget: _activeTargets.currentTarget,
          navigationTargets: navigationTargets,
          state: state,
          child: child,
        ),
      ),
    );
  }
}

class MainBody extends ConsumerWidget {
  const MainBody({
    required this.activeTarget,
    required this.state,
    required this.navigationTargets,
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;
  final GoRouterState state;
  final List<NavigationTarget> navigationTargets;
  final NavigationTarget activeTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Build MainBody => ${state.queryParams.toString()} ${activeTarget.contentPane.toString()}");

    NavigationStateNotifier navigationState = ref.read(navigationStateProvider);

    List<NavigationTarget>? _navigationTargets = List<NavigationTarget>.from(navigationTargets);
    _navigationTargets.retainWhere((navigationTarget) => navigationTarget.navigationRailDestination != null);
    return Scaffold(
      body: _navigationTargets.length > 1
          ? Row(
              children: <Widget>[
                LayoutBuilder(
                  builder: (context, constraint) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraint.maxHeight),
                        child: IntrinsicHeight(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: NavigationRail(
                              selectedIndex: ref.read(navigationStateProvider).currentIndex,
                              onDestinationSelected: (int index) {
                                navigationState.currentIndex = index;
                                NavigationTarget navigationTarget = _navigationTargets[index];
                                if (navigationTarget.navigationTabs == null) {
                                  context.go("/${navigationTarget.path}");
                                } else {
                                  context.go("/${navigationTarget.path}/${navigationTarget.navigationTabs!.first.path}");
                                }
                              },
                              labelType: NavigationRailLabelType.all,
                              destinations: <NavigationRailDestination>[
                                ..._navigationTargets.map((navigationTarget) {
                                  return navigationTarget.navigationRailDestination!;
                                })
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const VerticalDivider(thickness: 1, width: 1),
                // This is the main content.
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: child,
                      // child: activeTarget == null ? EmptyScreen() : activeTarget.contentPane,
                    ),
                  ),
                )
              ],
            )
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
            ),
    );
  }
}

class ActiveTarget {
  final NavigationTarget currentTarget;
  final NavigationTarget? parentTarget;

  ActiveTarget({required this.currentTarget, this.parentTarget});
}

class BarButtonShare extends ConsumerWidget {
  const BarButtonShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NavigationStateNotifier navigationState = ref.watch(navigationStateProvider);
    Map<String, String>? queryParams = navigationState.selectionState.queryParams;
    String? queryString;
    if (queryParams != null) {
      queryString = "/?${queryParams.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    return IconButton(
      onPressed: () {
        String url = "${Uri.base.replace(query: null).toString()}${queryString ?? ""}";
        FlutterClipboard.copy(url).then((_) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied current location ($url) to clipboard."), behavior: SnackBarBehavior.floating));
        });
      },
      icon: const Icon(Icons.share),
      tooltip: "Copy the current location to the paste buffer...",
    );
  }
}

class BarButtonDuplicate extends ConsumerWidget {
  const BarButtonDuplicate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NavigationStateNotifier navigationState = ref.watch(navigationStateProvider);
    Map<String, String>? queryParams = navigationState.selectionState.queryParams;
    String? queryString;
    if (queryParams != null) {
      queryString = "/?${queryParams.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    return IconButton(
      onPressed: () {
        String url = "${Uri.base.replace(query: null).toString()}${queryString ?? ""}";
        launch(url).then((_) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opened current location ($url) in new tab."), behavior: SnackBarBehavior.floating));
        });
      },
      icon: const Icon(Icons.open_in_new),
      tooltip: "Open the current page in a new tab...",
    );
  }
}

class BarButtonFeedback extends StatelessWidget {
  const BarButtonFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: () {
            String url = "https://github.com/postmeridiem/fframe/issues";
            launch(url).then((_) {
              return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opened GitHub issue tracker in a new tab."), behavior: SnackBarBehavior.floating));
            });
          },
          icon: const Icon(Icons.pest_control),
          tooltip: "Leave feedback...",
        );
      },
    );
  }
}

class BarButtonProfile extends StatelessWidget {
  const BarButtonProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const IconButton(
      onPressed: _signOut,
      icon: Icon(Icons.logout_outlined),
      tooltip: "Log out...",
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
