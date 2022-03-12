import 'dart:async';
import 'package:fframe/controllers/appUserStateController.dart';
import 'package:fframe/controllers/navigationStateController.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/navigation.dart';
import 'package:fframe/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fframe/firebase_config.dart';
import 'package:fframe/providers/globalProviders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

  runApp(
    RootRestorationScope(
      restorationId: 'root',
      child: ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            UserState userState = ref.watch(userStateNotifierProvider);

            if (userState.runtimeType != UserStateSignedIn && userState.runtimeType != UserStateSignedOut) {
              return UnknownStateLoader();
            }

            return App();
          },
        ),
      ),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static const title = "FlutFrame";

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
    List<NavigationTarget> _navigationTargets = isSignedIn ? List<NavigationTarget>.from(authenticatedNavigationTargets) : List<NavigationTarget>.from(unAuthenticatedNavigationTargets);
    NavigationTarget _initialNavigationTarget;
    //Return if unauthed

    if (!isSignedIn) {
      try {
        _initialNavigationTarget = _navigationTargets.singleWhere((navigationTarget) => navigationTarget.signInPage == true);
        _initialLocation = "/${_initialNavigationTarget.path}";
        return _navigationTargets;
      } catch (_) {
        throw ("The unAuthenticated NavigationTargets do not contain a target configured as initial Navigation target!");
      }
    }

    //Determine the first navigatablepath for this user
    _initialNavigationTarget = _navigationTargets.first;
    if (_initialNavigationTarget.navigationTabs == null) {
      _initialLocation = "/${_initialNavigationTarget.path}";
    } else {
      _initialLocation = "/${_initialNavigationTarget.path}/${_initialNavigationTarget.navigationTabs!.first.path}";
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
                transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
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
              child: CircularProgressIndicator(),
            );
          }
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ContentScreen(
              key: state.pageKey,
              navigationTarget: navigationTarget,
              goRouterState: state,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
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
              child: WaitScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
            );
          },
          routes: _goRouteTargets(_navigationTargets(userState)).toList(),
        ),
      ],
      redirect: (goRouterState) {
        if (!isSignedIn && goRouterState.subloc != '/' && goRouterState.subloc != "$_initialLocation") {
          print("<a> Redirect to $_initialLocation with deeplink to ${goRouterState.subloc}");
          ref.read(navigationStateProvider).redirectState = goRouterState.subloc;
        }

        if (isSignedIn && goRouterState.queryParams.containsKey('redirectTo')) {
          print("<b> Redirect to queryParam instuction ${goRouterState.queryParams["redirectTo"]}");
          return goRouterState.queryParams["redirectTo"];
        }
        // String _deepLink =  ? '?redirectTo=${goRouterState.subloc}' : '';

        // print("RedirectRequest to ${goRouterState.subloc} _initialLocation: $_initialLocation deepLink: $_deepLink");

        if (goRouterState.subloc == "/" && goRouterState.subloc != _initialLocation) {
          print("<c> Redirect to $_initialLocation");
          return "$_initialLocation";
        }

        if (goRouterState.queryParams.length != 0) {
          print("Process redirect");
          String? routeId = goRouterState.queryParams['id'];
          if (routeId != null) {
            SelectionState selectionState = SelectionState(queryDocumentSnapshot: null, queryParams: {"id": routeId}, cardId: routeId);
            ref.read(navigationStateProvider.notifier).selectionState = selectionState;
          }
        }
        print("No redirection");
        return null;
      },
      errorBuilder: (context, state) => ErrorScreen(error: state.error!, initiallLocation: _initialLocation),
      navigatorBuilder: (context, state, child) {
        return MainScreen(
          key: state.pageKey,
          appTitle: App.title,
          child: child,
          state: state,
          navigationTargets: _navigationTargets(userState),
        );
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
          locale: const Locale('en'),
        );
      },
    );
  }
}

class UnknownStateLoader extends StatelessWidget {
  const UnknownStateLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaitScreen();
  }
}
