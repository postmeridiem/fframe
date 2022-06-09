import 'package:fframe/helpers/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

class MainScreen extends StatefulWidget {
  final String appTitle;
  final String? issuePageLink;
  final L10nConfig l10nConfig;
  const MainScreen({
    Key? key,
    required this.appTitle,
    required this.l10nConfig,
    this.issuePageLink,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("fFrame Example"),
        leading: IconButton(
            onPressed: () {
              if (_scaffoldKey.currentState!.isDrawerOpen) {
                _scaffoldKey.currentState!.closeDrawer();
              } else {
                _scaffoldKey.currentState!.openDrawer();
              }
            },
            icon: const Icon(Icons.menu)),
        actions: [
          if (FRouter.of(context).isSignedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FRouter.of(context).logout();
              },
            ),
          IconButton(
              onPressed: () {
                if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                  _scaffoldKey.currentState!.closeEndDrawer();
                } else {
                  _scaffoldKey.currentState!.openEndDrawer();
                }
              },
              icon: const Icon(Icons.menu)),
        ],
      ),
      drawer: FRouter.of(context).drawer(
        context: context,
        drawerHeader: const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text("FRouter Example"),
        ),
        signOutDestination: const Destination(
          icon: Icon(Icons.logout),
          label: Text("Sign out"),
        ),
      ),
      endDrawer: FRouter.of(context).drawer(
        context: context,
      ),
      body: Center(
        child: Row(
          children: [
            FRouter.of(context).navigationRail(
              signOutDestination: const NavigationRailDestination(
                icon: Icon(Icons.logout),
                label: Text("Sign out"),
              ),
            ),
            const VerticalDivider(
              color: Colors.blueGrey,
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  TargetState targetState = ref.watch(targetStateProvider);
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      key: ValueKey("navTarget_${targetState.navigationTarget.title}"),
                      child: targetState.navigationTarget.contentPane,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class MainScreen extends StatelessWidget {
//   final String appTitle;
//   final String? issuePageLink;
//   // final Widget child;
//   // final NavigationState navigationState;
//   // final List<NavigationTarget> navigationTargets;
//   final ThemeData darkMode;
//   final ThemeData lightMode;
//   // final L10nConfig l10nConfig;
//   const MainScreen({
//     Key? key,
//     required this.appTitle,
//     // required this.child,
//     // required this.navigationState,
//     // required this.navigationTargets,
//     required this.darkMode,
//     required this.lightMode,
//     // required this.l10nConfig,
//     this.issuePageLink,
//   }) : super(key: key);

//   // ActiveTarget getActiveTarget() {
//   //   try {
//   //     //This is the only applicable target
//   //     if (navigationTargets.length == 1) {
//   //       return ActiveTarget(currentTarget: navigationTargets.first);
//   //     }
//   //     //Get the first applicable target
//   //     // navigationState.
//   //     // List<String> subloc = state.subloc.split('/');
//   //     List<String> subloc = ["suggestions"];
//   //     subloc.removeWhere((String element) => element == ''); //Clean out any empty strings
//   //     List<NavigationTarget> _navigationTargets = List<NavigationTarget>.from(navigationTargets);

//   //     NavigationTarget? activeTarget = _navigationTargets.firstWhere((navigationTarget) => navigationTarget.path == subloc.first);
//   //     if (subloc.length == 1) {
//   //       return ActiveTarget(currentTarget: activeTarget, parentTarget: null);
//   //     } else {
//   //       activeTarget = activeTarget.navigationTabs!.firstWhere((navigationTarget) => navigationTarget.path == subloc.last);

//   //       // activeTarget = _navigationTargets.firstWhere((navigationTarget) => navigationTarget.path == subloc.join('/'));
//   //       return ActiveTarget(currentTarget: activeTarget, parentTarget: null);
//   //     }

//   //     // //Research the tabs
//   //     // if (_navigationTargets.first.navigationTabs != null) {
//   //     //   List<NavigationTarget> _parentNavigationTargets = List<NavigationTarget>.from(_navigationTargets.first.navigationTabs!);
//   //     //   _parentNavigationTargets.removeWhere((NavigationTarget navigationTarget) => navigationTarget.path != subloc.last);
//   //     //   return ActiveTarget(currentTarget: _parentNavigationTargets.first, parentTarget: _navigationTargets.first);
//   //     // }
//   //   } catch (e) {
//   //     debugPrint("Exception on getActiveTarget. could not determine selected target: ${e.toString()}");
//   //     return ActiveTarget(currentTarget: navigationTargets.first);
//   //   }
//   // }

//   // String _pageTitle(ActiveTarget activeTarget) {
//   //   return (activeTarget.parentTarget == null) ? activeTarget.currentTarget.title : "${activeTarget.parentTarget!.title} - ${activeTarget.currentTarget.title}";
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // debugPrint("Build mainScreen ${state.location} ${state.queryParams.toString()}");

//     // if (navigationTargets.isEmpty) {
//     //   return const EmptyScreen();
//     // }

//     // ActiveTarget? _activeTarget = getActiveTarget();
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//     // String pageTitle = _pageTitle(_activeTarget);

//     // return MaterialApp(
//     //   debugShowCheckedModeBanner: false,
//     //   title: appTitle,
//     //   theme: lightMode,
//     //   darkTheme: darkMode,
//     //   themeMode: ThemeMode.system,
//     //   localizationsDelegates: L10n.getDelegates(),
//     //   supportedLocales: L10n.getLocales(),
//     //   locale: L10n.getLocale(),

//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Consumer(
//           builder: (context, ref, _) {
//             return const Text("todo: title");
//             // String subTitle = ref.watch(navigationStateProvider).state.currentTarget?.title != null ? ":: ${ref.watch(navigationStateProvider).state.currentTarget!.title}" : "";
//             // return (subTitle.isEmpty) ? Text(pageTitle) : Text("$pageTitle - $subTitle");
//           },
//         ),
//         actions: [
//           const BarButtonShare(),
//           const BarButtonDuplicate(),
//           BarButtonFeedback(issuePageLink: issuePageLink),
//           if (FirebaseAuth.instance.currentUser != null) const BarButtonProfile(),
//         ],
//       ),
//       body: const Text("We have loaded"),
//     );
//   }
// }

// // class MainBody extends ConsumerWidget {
// //   const MainBody({
// //     // required this.activeTarget,
// //     // required this.state,
// //     // required this.navigationTargets,
// //     Key? key,
// //     this.child,
// //   }) : super(key: key);
// //   final Widget? child;
// //   // final GoRouterState state;
// //   // final List<NavigationTarget> navigationTargets;
// //   // final NavigationTarget? activeTarget;

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     // debugPrint("Build MainBody => ${state.queryParams.toString()} ${activeTarget?.contentPane.toString()}");

// //     // NavigationStateNotifier navigationState = ref.read(navigationStateProvider);

// //     // List<NavigationTarget>? _navigationTargets = List<NavigationTarget>.from(navigationTargets);
// //     // _navigationTargets.retainWhere((navigationTarget) => navigationTarget.navigationRailDestination != null);
// //     return Scaffold(
// //       body:
// //           //  _navigationTargets.length > 1
// //           //     ? Row(
// //           //         children: <Widget>[
// //           //           // TODO: Navbar goes here
// //           //           // LayoutBuilder(
// //           //           //   builder: (context, constraint) {
// //           //           //     return SingleChildScrollView(
// //           //           //       child: ConstrainedBox(
// //           //           //         constraints: BoxConstraints(minHeight: constraint.maxHeight),
// //           //           //         child: IntrinsicHeight(
// //           //           //           child: AnimatedSwitcher(
// //           //           //             duration: const Duration(milliseconds: 500),
// //           //           //             child: IconTheme(
// //           //           //               data: const IconThemeData(color: null),
// //           //           //               child: NavigationRail(
// //           //           //                 selectedIndex: ref.read(navigationStateProvider).currentIndex,
// //           //           //                 onDestinationSelected: (int index) {
// //           //           //                   navigationState.currentIndex = index;
// //           //           //                   NavigationTarget navigationTarget = _navigationTargets[index];
// //           //           //                   if (navigationTarget.navigationTabs == null) {
// //           //           //                     context.go("/${navigationTarget.path}");
// //           //           //                   } else {
// //           //           //                     context.go("/${navigationTarget.path}/${navigationTarget.navigationTabs!.first.path}");
// //           //           //                   }
// //           //           //                 },
// //           //           //                 labelType: NavigationRailLabelType.all,
// //           //           //                 destinations: <NavigationRailDestination>[
// //           //           //                   ..._navigationTargets.map((navigationTarget) {
// //           //           //                     return navigationTarget.navigationRailDestination!;
// //           //           //                   })
// //           //           //                 ],
// //           //           //               ),
// //           //           //             ),
// //           //           //           ),
// //           //           //         ),
// //           //           //       ),
// //           //           //     );
// //           //           //   },
// //           //           // ),
// //           //           const VerticalDivider(thickness: 1, width: 1),
// //           //           // This is the main content.
// //           //           Expanded(
// //           //             child: AnimatedSwitcher(
// //           //               duration: const Duration(milliseconds: 300),
// //           //               child: child,
// //           //             ),
// //           //           )
// //           //         ],
// //           //       )
// //           //     :
// //           AnimatedSwitcher(
// //         duration: const Duration(milliseconds: 300),
// //         child: child,
// //       ),
// //     );
// //   }
// // }

// // class ActiveTarget {
// //   final NavigationTarget currentTarget;
// //   final NavigationTarget? parentTarget;

// //   ActiveTarget({required this.currentTarget, this.parentTarget});
// // }
