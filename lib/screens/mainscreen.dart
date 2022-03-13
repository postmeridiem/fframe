import 'dart:js' as js;

import 'package:fframe/controllers/navigationStateController.dart';
import 'package:fframe/providers/globalProviders.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fframe/components/theme_light.dart';
import 'package:fframe/components/theme_dark.dart';

import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatelessWidget {
  final String appTitle;
  final Widget child;
  final GoRouterState state;
  final List<NavigationTarget> navigationTargets;
  const MainScreen({
    Key? key,
    required this.appTitle,
    required this.child,
    required this.state,
    required this.navigationTargets,
  }) : super(key: key);

  ActiveTarget getActiveTarget() {
    List<String> subloc = state.subloc.split('/');
    subloc.removeWhere((String element) => element == ''); //Clean out any empty strings
    List<NavigationTarget> _navigationTargets = List<NavigationTarget>.from(navigationTargets);

    //Remove any targets which are not currently loaded....
    _navigationTargets.removeWhere((NavigationTarget navigationTarget) => navigationTarget.path != subloc.first);
    if (_navigationTargets.length == 1 && subloc.length == 1) return ActiveTarget(currentTarget: _navigationTargets.first);
    ; //This is the only applicable target

    //Research the tabs
    List<NavigationTarget> _parentNavigationTargets = List<NavigationTarget>.from(_navigationTargets.first.navigationTabs!);
    _parentNavigationTargets.removeWhere((NavigationTarget navigationTarget) => navigationTarget.path != subloc.last);
    return ActiveTarget(currentTarget: _parentNavigationTargets.first, parentTarget: _navigationTargets.first);
  }

  String _pageTitle(ActiveTarget activeTarget) {
    return (activeTarget.parentTarget == null)
        ? "${activeTarget.currentTarget.title}"
        : "${activeTarget.parentTarget!.title} - ${activeTarget.currentTarget.title}";
  }

  @override
  Widget build(BuildContext context) {
    print("Build mainScreen ${this.state.location} ${this.state.queryParams.toString()}");
    ActiveTarget _activeTargets = getActiveTarget();

    String pageTitle = _pageTitle(_activeTargets);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: this.appTitle,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Consumer(
            builder: (context, ref, _) {
              String subTitle =
                  ref.watch(navigationStateProvider).currentTarget?.title != null ? ":: ${ref.watch(navigationStateProvider).currentTarget!.title}" : "";
              return (subTitle.isEmpty) ? Text("${pageTitle}") : Text("${pageTitle} - ${subTitle}");
            },
          ),
          actions: [
            BarButtonShare(context),
            BarButtonFeedback(context),
            BarButtonProfile(context),
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
  MainBody({
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
    print("Build MainBody => ${state.queryParams.toString()} ${this.activeTarget.contentPane.toString()}");

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
                            duration: Duration(milliseconds: 500),
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

class BarButtonShare extends StatelessWidget {
  const BarButtonShare(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: () {
            FlutterClipboard.copy(Uri.base.toString()).then((_) {
              return ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Copied current location (${Uri.base.toString()}) to clipboard."), behavior: SnackBarBehavior.floating));
            });
          },
          icon: Icon(Icons.share),
          tooltip: "Copy the current location to the paste buffer...",
        );
      },
    );
  }
}

class BarButtonFeedback extends StatelessWidget {
  const BarButtonFeedback(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: () {
            // link to google feedback form
            js.context.callMethod('open', ['https://github.com/postmeridiem/fframe/issues']);
          },
          icon: Icon(Icons.pest_control),
          tooltip: "Leave feedback...",
        );
      },
    );
  }
}

class BarButtonProfile extends StatelessWidget {
  const BarButtonProfile(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: _signOut,
          icon: Icon(Icons.logout_outlined),
          tooltip: "Log out...",
        );
      },
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
