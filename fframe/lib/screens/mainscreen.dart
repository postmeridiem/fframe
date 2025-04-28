import 'package:fframe/services/navigation_service.dart';
import 'package:flutter/material.dart';

import 'package:fframe/constants/constants.dart';
import 'package:fframe/helpers/l10n.dart';
import 'package:fframe/fframe.dart';

// import 'package:url_launcher/url_launcher.dart';

// import '../helpers/profile_buttons.dart';

class MainScreen extends StatefulWidget {
  final String appTitle;
  final L10nConfig l10nConfig;
  const MainScreen({
    super.key,
    required this.appTitle,
    required this.l10nConfig,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // late TabController _subTabController;
  // late OverlayState overlayState;
  // late OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = (MediaQuery.of(context).size.width <= 400)
        ? ScreenSize.phone
        : (MediaQuery.of(context).size.width < 1000)
            ? ScreenSize.tablet
            : ScreenSize.large;

    Console.log("Build to size: ${screenSize.toString()}", scope: "fframeLog.MainScreen", level: LogLevel.fframe);

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            elevation: 2,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
            title: Text(Fframe.of(context)?.title ?? ""),
            leading: (ScreenSize.phone == screenSize || ScreenSize.tablet == screenSize)
                ? IconButton(
                    onPressed: () {
                      if (_scaffoldKey.currentState!.isDrawerOpen) {
                        _scaffoldKey.currentState!.closeDrawer();
                      } else {
                        _scaffoldKey.currentState!.openDrawer();
                      }
                    },
                    icon: const Icon(Icons.menu))
                : const IgnorePointer(),
            actions: [
              ...?Fframe.of(context)?.globalActions,
              // TODO JS: make this work directly through the notification class
              (Fframe.of(context)?.enableNotficationSystem ?? false)
                  ? NotificationButton(
                      userId: Fframe.of(context)!.user!.id!,
                    )
                  : const IgnorePointer(),
              const ProfileButton(),
            ],
          ),
          drawer: FRouter.of(context).drawer(
            context: context,
            drawerHeader: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                widget.appTitle,
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          ),
          body: Row(
            children: [
              if (screenSize == ScreenSize.large)
                Container(
                  alignment: Alignment.topCenter,
                  color: Theme.of(context).colorScheme.surface,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: IntrinsicHeight(
                      child: FRouter.of(context).navigationRail(),
                    ),
                  ),
                ),
              ListenableBuilder(
                listenable: TargetState.instance,
                builder: (context, _) {
                  NavigationTarget navigationTarget = TargetState.instance.navigationTarget;
                  return Expanded(
                    child: Scaffold(
                      primary: false,
                      appBar: FAppBarLoader(
                        context: context,
                      ),
                      body: Scaffold(
                        primary: false,
                        appBar: AppBar(
                          toolbarHeight: 0,
                        ),
                        body: Container(
                          key: ValueKey("navTarget_${navigationTarget.path}"),
                          child: navigationTarget.contentPane,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const MinimizedDocumentsWatcher(),
      ],
    );
  }
}

class FAppBarLoader extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const FAppBarLoader({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    FRouter fRouter = FRouter.of(context);
    return ListenableBuilder(
        listenable: TargetState.instance,
        builder: (context, _) {
          final hasTabs = fRouter.hasTabs;
          final tabLength = fRouter.tabLength;
          if (hasTabs && tabLength > 1) {
            return FAppBar(
              hasTabs: hasTabs,
              tabLength: tabLength,
            );
          } else {
            return const IgnorePointer();
          }
        });
  }

  @override
  Size get preferredSize => Size.fromHeight((FRouter.of(context).hasTabs && FRouter.of(context).tabLength > 1) ? kToolbarHeight : 0);
}

class FAppBar extends StatefulWidget {
  final bool hasTabs;
  final int tabLength;
  const FAppBar({
    super.key,
    required this.hasTabs,
    required this.tabLength,
  });

  @override
  State<FAppBar> createState() => _FAppBarState();
}

class _FAppBarState extends State<FAppBar> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(
      initialIndex: FRouter.of(context).currentTab,
      vsync: this,
      length: FRouter.of(context).tabLength,
    );

    _tabController.addListener(
      () => FRouter.of(context).tabSwitch(tabController: _tabController),
    );

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      toolbarHeight: kToolbarHeight,
      bottom: TabBar(
        labelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        controller: _tabController, // Make sure this is initialized correctly
        tabs: FRouter.of(context).tabBar(context),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  late OverlayState overlayState;

  late OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) {
    overlayState = Overlay.of(context);
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const CircularProgressIndicator();
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.done:
            return const IgnorePointer();
          case ConnectionState.active:
            if (snapshot.hasError) {
              return Icon(Icons.error, color: Theme.of(context).colorScheme.error);
            }

            if (snapshot.hasData) {
              return TextButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(4), // <-- Splash color
                ),
                onPressed: () {
                  showUserOverlay();
                },
                child: circleAvatar(),
              );
            }
            return const IgnorePointer();
        }
      },
    );
  }

  CircleAvatar circleAvatar({double? radius}) {
    User user = FirebaseAuth.instance.currentUser!;
    List<String>? avatarText = user.displayName?.split(' ').map((part) => part.trim().substring(0, 1)).toList();
    return CircleAvatar(
      radius: radius ?? 12.0,
      backgroundImage: (user.photoURL == null) ? null : NetworkImage(user.photoURL!),
      backgroundColor: (user.photoURL == null) ? Colors.amber : Colors.transparent,
      child: (user.photoURL == null && avatarText != null)
          ? Text(
              "${avatarText.first}${avatarText.last}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          : null,
    );
  }

  showUserOverlay() {
    overlayEntry = OverlayEntry(builder: (context) {
      return Stack(
        children: <Widget>[
          Positioned.fill(
              child: GestureDetector(
            onTap: () {
              overlayEntry.remove();
            },
            child: Container(
              color: Colors.transparent,
            ),
          )),
          Positioned(
            top: kToolbarHeight,
            right: 5.0,
            child: Material(
              color: Theme.of(context).colorScheme.secondary,
              child: SizedBox(
                height: 400.0,
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        mouseCursor: SystemMouseCursors.click,
                        leading: circleAvatar(
                          radius: 24,
                        ),
                        title: Text(
                          FirebaseAuth.instance.currentUser!.displayName!,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        // subtitle: Text(
                        //   L10n.string("header_profilelabel", placeholder: "Click to open profile...", namespace: "fframe"),
                        //   style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 12),
                        // ),
                        onTap: () {
                          // FRouter.of(context).navigateToRoute(context, route: "profile");
                          List<NavigationTarget> navigationTargets = NavigationNotifier.instance.navigationConfig.navigationTargets;
                          NavigationTarget profilePageTarget = navigationTargets.firstWhere(
                            (NavigationTarget navigationTarget) {
                              return navigationTarget.profilePage == true;
                            },
                            orElse: () {
                              return NavigationNotifier.instance.navigationConfig.errorPage;
                            },
                          );
                          NavigationNotifier.instance.processRouteInformation(
                            targetState: TargetState(
                              navigationTarget: profilePageTarget,
                            ),
                          );
                          overlayEntry.remove();
                          // FRouter.of(context).navigateTo(navigationTarget: profilePageTarget);
                        },
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    const Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          // ThemeDropdown(),
                          // LocaleDropdown(),
                        ],
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
                      child: TextButton.icon(
                        onPressed: () async {
                          // setState(() {
                          //   isSigningOut = true;
                          // });
                          await FirebaseAuth.instance.signOut();
                          overlayEntry.remove();
                        },
                        icon: Icon(Icons.logout, size: 24.0, color: Theme.of(context).colorScheme.onSecondary),
                        label: Text(
                          L10n.string("header_signout", placeholder: "Sign out...", namespace: "fframe"),
                          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });

    overlayState.insert(overlayEntry);
  }
}
