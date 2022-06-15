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
        // title: const Text("fFrame Example"),
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
