part of fframe;

class Fframe extends StatefulWidget {
  const Fframe({
    Key? key,
    this.title = "FlutFrame",
    required this.firebaseOptions,
    required this.authenticatedNavigationTargets,
    required this.unAuthenticatedNavigationTargets,
    required this.darkMode,
    required this.lightMode,
    required this.l10nConfig,
    this.issuePageLink,
  }) : super(key: key);
  final String title;
  final String? issuePageLink;
  final FirebaseOptions firebaseOptions;
  final List<NavigationTarget> authenticatedNavigationTargets;
  final List<NavigationTarget> unAuthenticatedNavigationTargets;
  final ThemeData darkMode;
  final ThemeData lightMode;
  final L10nConfig l10nConfig;

  @override
  State<Fframe> createState() => _FframeState();
}

class _FframeState extends State<Fframe> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: widget.firebaseOptions,
      ),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // debugPrint(snapshot.connectionState.toString());
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return RootRestorationScope(
              restorationId: 'fframe',
              child: ProviderScope(
                child: Consumer(
                  builder: (context, ref, child) {
                    UserState userState = ref.watch(userStateNotifierProvider);

                    if (userState.runtimeType != UserStateSignedIn &&
                        userState.runtimeType != UserStateSignedOut) {
                      return const UnknownStateLoader();
                    }

                    return App(
                      title: widget.title,
                      issuePageLink: widget.issuePageLink,
                      authenticatedNavigationTargets:
                          widget.authenticatedNavigationTargets,
                      unAuthenticatedNavigationTargets:
                          widget.unAuthenticatedNavigationTargets,
                      lightMode: widget.lightMode,
                      darkMode: widget.darkMode,
                      l10nConfig: widget.l10nConfig,
                    );
                  },
                ),
              ),
            );
        }
      },
    );
  }
}

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.title,
    required this.authenticatedNavigationTargets,
    required this.unAuthenticatedNavigationTargets,
    required this.darkMode,
    required this.lightMode,
    required this.l10nConfig,
    this.issuePageLink,
  }) : super(key: key);

  final String title;
  final String? issuePageLink;
  final List<NavigationTarget> authenticatedNavigationTargets;
  final List<NavigationTarget> unAuthenticatedNavigationTargets;
  final ThemeData darkMode;
  final ThemeData lightMode;
  final L10nConfig l10nConfig;

  // global access to a buildcontext, so I can access the translation from anywhere.
  static BuildContext context =
      GlobalKey<NavigatorState>().currentContext as BuildContext;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with RestorationMixin {
  @override
  String get restorationId => 'wrapper';
  String _initialLocation = '/';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // todo: implement restoreState for you app
  }

  List<NavigationTarget> _navigationTargets(UserState userState) {
    //Get the current auth state
    bool isSignedIn = userState.runtimeType == UserStateSignedIn;
    List<NavigationTarget> _navigationTargets = isSignedIn
        ? List<NavigationTarget>.from(widget.authenticatedNavigationTargets)
        : List<NavigationTarget>.from(widget.unAuthenticatedNavigationTargets);
    NavigationTarget _initialNavigationTarget;
    //Return if unauthed

    if (!isSignedIn) {
      try {
        _initialNavigationTarget = _navigationTargets.singleWhere(
            (navigationTarget) => navigationTarget.signInPage == true);
        _initialLocation = "/${_initialNavigationTarget.path}";
        return _navigationTargets;
      } catch (_) {
        throw ("The unAuthenticated NavigationTargets do not contain a target configured as initial Navigation target!");
      }
    } else {
      debugPrint("Signed in user, filter on roles");
      UserStateSignedIn _userState = userState as UserStateSignedIn;

      if (_userState.appUser.roles == null) {
        debugPrint("Remove all paths wich require a role");
        _navigationTargets
            .removeWhere((navigationTarget) => navigationTarget.roles != null);
      } else {
        List<String> userRoles = _userState.appUser.roles!;
        debugPrint("Current user roles: ${userRoles.join(",")}");

        _navigationTargets.removeWhere((navigationTarget) {
          if (navigationTarget.roles == null) {
            debugPrint("Allow ${navigationTarget.title}");
            return true;
          }
          List<String> targetRoles = navigationTarget.roles!
              .map((targetRole) => targetRole.toLowerCase())
              .toList();
          debugPrint(
              "Roles for ${navigationTarget.title}: ${targetRoles.join(",")}");
          bool allow = !targetRoles.any(
            (targetRole) => userRoles.contains(targetRole),
          );
          debugPrint(
              "Allowed roles for ${navigationTarget.title}: ${targetRoles.join(",")} => $allow");
          return allow;
        });
      }
    }

    if (_navigationTargets.isNotEmpty) {
      //Determine the first navigatablepath for this user
      _initialNavigationTarget = _navigationTargets.first;
      if (_initialNavigationTarget.navigationTabs == null) {
        _initialLocation = "/${_initialNavigationTarget.path}";
      } else {
        _initialLocation =
            "/${_initialNavigationTarget.path}/${_initialNavigationTarget.navigationTabs!.first.path}";
      }
    } else {
      debugPrint("No routes available");
      _navigationTargets.add(
        NavigationTarget(
          path: 'error',
          title: "configuration error",
          contentPane: ErrorScreen(
            error: Exception("No routes left after evaluating user access."),
          ),
        ),
      );
      _initialNavigationTarget = _navigationTargets.first;
      _initialLocation = "/${_initialNavigationTarget.path}";
    }
    return _navigationTargets;
  }

  Iterable<GoRoute> _goRouteTargets(List<NavigationTarget> navigationTargets) {
    return navigationTargets.map((navigationTarget) {
      //Prepare the subtabs
      List<GoRoute>? navigationTabs = navigationTarget.navigationTabs?.map(
        (NavigationTab navigationTab) {
          return GoRoute(
            path: navigationTab.path,
            name: navigationTab.path,
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: ContentScreen(
                  key: state.pageKey,
                  navigationTarget: navigationTarget,
                  goRouterState: state,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ).toList();

      //Apply the main routes. Add the subtabs if needed
      return GoRoute(
        path: navigationTarget.path,
        name: navigationTarget.path,
        pageBuilder: (context, state) {
          if (navigationTarget.navigationTabs != null) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const CircularProgressIndicator(),
            );
          }
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ContentScreen(
              key: state.pageKey,
              navigationTarget: navigationTarget,
              goRouterState: state,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        routes: navigationTarget.navigationTabs != null ? navigationTabs! : [],
      );
    }).toList();
  }

  GoRouter _goRouter(WidgetRef ref) {
    UserState userState = ref.watch(userStateNotifierProvider);
    bool isSignedIn = userState.runtimeType == UserStateSignedIn;
    _navigationTargets(userState);

    return GoRouter(
      debugLogDiagnostics: false,
      restorationScopeId: 'router',
      routes: [
        GoRoute(
          path: '/',
          name: '/',
          pageBuilder: (context, state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const WaitScreen(
                color: Colors.blueGrey,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            );
          },
          routes: _goRouteTargets(_navigationTargets(userState)).toList(),
        ),
      ],
      redirect: (goRouterState) {
        if (!isSignedIn &&
            goRouterState.subloc != '/' &&
            goRouterState.subloc != _initialLocation) {
          debugPrint(
              "<a> Redirect to $_initialLocation with deeplink to ${goRouterState.subloc}");
          ref.read(navigationStateProvider).state.redirectState =
              goRouterState.subloc;
        }

        if (isSignedIn && goRouterState.queryParams.containsKey('redirectTo')) {
          debugPrint(
              "<b> Redirect to queryParam instuction ${goRouterState.queryParams["redirectTo"]}");
          return goRouterState.queryParams["redirectTo"];
        }
        // String _deepLink =  ? '?redirectTo=${goRouterState.subloc}' : '';

        // debugPrint("RedirectRequest to ${goRouterState.subloc} _initialLocation: $_initialLocation deepLink: $_deepLink");

        if (goRouterState.subloc == "/" &&
            goRouterState.subloc != _initialLocation) {
          debugPrint("<c> Redirect to $_initialLocation");
          return _initialLocation;
        }

        if (goRouterState.queryParams.isNotEmpty) {
          debugPrint("Process redirect");
          SelectionState selectionState = SelectionState(
              data: null, queryParams: goRouterState.queryParams, docId: null);
          ref.read(selectionStateProvider.notifier).state = selectionState;
          return null;
        }

        // NavigationStateNotifier navigationState = ref.read(navigationStateProvider);

        debugPrint("No redirection, return Null");
        return null;
      },
      // errorBuilder: (context, state) => ErrorScreen(error: state.error!, initiallLocation: _initialLocation),
      navigatorBuilder: (context, state, child) {
        try {
          debugPrint("-=-=-=-=-=-=-navigatorBuilder rebuild=-=-=-=-=-=-=-=-=-");
          List<NavigationTarget> navigationTargets =
              _navigationTargets(userState);

          // if (navigationTargets.isNotEmpty) {
          return MainScreen(
            key: state.pageKey,
            appTitle: widget.title,
            child: child,
            issuePageLink: widget.issuePageLink,
            navigationTargets: navigationTargets,
            lightMode: widget.lightMode,
            darkMode: widget.darkMode,
            l10nConfig: widget.l10nConfig,
          );
          // } else {
          //   return ErrorScreen(error: Exception("Nowhere to route to."));
          // }
        } catch (e) {
          return ErrorScreen(
            error: Exception(e),
            initiallLocation: _initialLocation,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        GoRouter _router = _goRouter(ref);

        return MaterialApp.router(
          restorationScopeId: 'app',
          // routeInformationProvider:
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          //TODO hook this up to the l10n config?
          locale: const Locale('en'),
          builder: (BuildContext context, Widget? widget) {
            // debugPrint("builder");
            Widget error = const Text('...rendering error...');
            if (widget is Scaffold || widget is Navigator) {
              error = Scaffold(body: Center(child: error));
            }
            ErrorWidget.builder = (FlutterErrorDetails details) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: Colors.yellowAccent,
                    ),
                    title: Text(
                      details.exception.toString(),
                      // style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              );
            };
            return widget!;
          },
        );
      },
    );
  }
}

class UnknownStateLoader extends StatelessWidget {
  const UnknownStateLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WaitScreen(
      color: Colors.blueAccent,
    );
  }
}
