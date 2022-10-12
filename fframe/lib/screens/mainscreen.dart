import 'package:flutter/material.dart';

import 'package:fframe/constants/constants.dart';
import 'package:fframe/providers/state_providers.dart';
import 'package:fframe/helpers/l10n.dart';
import 'package:fframe/fframe.dart';

import '../helpers/profile_buttons.dart';

class MainScreen extends StatefulWidget {
  final String appTitle;
  final L10nConfig l10nConfig;
  const MainScreen({
    Key? key,
    required this.appTitle,
    required this.l10nConfig,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  late TabController _subTabController;
  // late OverlayState overlayState;
  // late OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = (MediaQuery.of(context).size.width <= 400)
        ? ScreenSize.phone
        : (MediaQuery.of(context).size.width < 1000)
            ? ScreenSize.tablet
            : ScreenSize.large;

    debugPrint("Build _MainScreenState ${screenSize.toString()}");

    if (FRouter.of(context).hasTabs) {
      _tabController = TabController(
        initialIndex: FRouter.of(context).currentTab,
        vsync: this,
        length: FRouter.of(context).tabLength,
      );

      _tabController.addListener(
        () => FRouter.of(context).tabSwitch(tabController: _tabController),
      );
    }

    if (FRouter.of(context).hasSubTabs) {
      _subTabController = TabController(
        initialIndex: FRouter.of(context).currentSubTab,
        vsync: this,
        length: FRouter.of(context).subTabLength,
      );

      _subTabController.addListener(
        () => FRouter.of(context).tabSwitch(tabController: _subTabController),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Text(Fframe.of(context)?.title ?? ""),
        leading:
            (ScreenSize.phone == screenSize || ScreenSize.tablet == screenSize)
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
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
      ),
      body: Row(
        children: [
          if (screenSize == ScreenSize.large)
            FRouter.of(context).navigationRail(),
          Expanded(
            child: Scaffold(
              primary: false,
              appBar: AppBar(
                toolbarHeight: 0,
                bottom: FRouter.of(context).hasTabs
                    ? TabBar(
                        labelColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        controller: _tabController,
                        tabs: FRouter.of(context).tabBar(context),
                      )
                    : null,
              ),
              body: Scaffold(
                primary: false,
                appBar: AppBar(
                  toolbarHeight: 0,
                  bottom: FRouter.of(context).hasSubTabs
                      ? TabBar(
                          labelColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          unselectedLabelColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          controller: _subTabController,
                          tabs: FRouter.of(context).subTabBar(context),
                        )
                      : null,
                ),
                body: Consumer(
                  builder: (context, ref, child) {
                    TargetState targetState = ref.watch(targetStateProvider);
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Container(
                        key: ValueKey(
                            "navTarget_${targetState.navigationTarget.title}"),
                        child: targetState.navigationTarget.contentPane,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }
}

class ProfileButton extends StatefulWidget {
  const ProfileButton({Key? key}) : super(key: key);

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  late OverlayState overlayState;

  late OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) {
    overlayState = Overlay.of(context)!;
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
              return Icon(Icons.error,
                  color: Theme.of(context).colorScheme.error);
            }

            if (snapshot.hasData) {
              return TextButton(
                child: circleAvatar(),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(4),
                  primary: Theme.of(context)
                      .colorScheme
                      .primaryContainer, // <-- Button color
                  onPrimary: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer, // <-- Splash color
                ),
                onPressed: () {
                  showUserOverlay();
                },
              );
            }
            return const IgnorePointer();
        }
      },
    );
  }

  CircleAvatar circleAvatar({double? radius}) {
    User user = FirebaseAuth.instance.currentUser!;
    List<String>? avatarText = user.displayName
        ?.split(' ')
        .map((part) => part.trim().substring(0, 1))
        .toList();
    return CircleAvatar(
      radius: radius ?? 12.0,
      backgroundImage:
          (user.photoURL == null) ? null : NetworkImage(user.photoURL!),
      backgroundColor:
          (user.photoURL == null) ? Colors.amber : Colors.transparent,
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
      bool isSigningOut = false;
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
                      child: OutlinedButton(
                        child: ListTile(
                          mouseCursor: SystemMouseCursors.click,
                          leading: circleAvatar(
                            radius: 24,
                          ),
                          title: Text(
                            FirebaseAuth.instance.currentUser!.displayName!,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                          subtitle: Text(
                            L10n.string("header_profilelabel",
                                placeholder: "Click to open profile...",
                                namespace: "fframe"),
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 12),
                          ),
                        ),
                        onPressed: (() {
                          FRouter.of(context)
                              .navigateToRoute(context, route: "profile");
                        }),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: const [
                          ThemeDropdown(),
                          LocaleDropdown(),
                        ],
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 8, bottom: 16),
                      child: TextButton.icon(
                        onPressed: () async {
                          setState(() {
                            isSigningOut = true;
                          });
                          await FirebaseAuth.instance.signOut();
                          overlayEntry.remove();
                        },
                        icon: isSigningOut
                            ? const CircularProgressIndicator()
                            : Icon(Icons.logout,
                                size: 24.0,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                        label: Text(
                          L10n.string("header_signout",
                              placeholder: "Sign out...", namespace: "fframe"),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
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
