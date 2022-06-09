import 'models.dart';

class NavigationConfig {
  final List<NavigationTarget> navigationTargets;
  final SignInConfig signInConfig;
  final NavigationTarget errorPage;
  final NavigationTarget emptyPage;
  final NavigationTarget waitPage;
  NavigationConfig({
    required this.signInConfig,
    required this.navigationTargets,
    required this.errorPage,
    required this.emptyPage,
    required this.waitPage,
  });

  factory NavigationConfig.clone(NavigationConfig navigationConfig) {
    List<NavigationTarget> navigationTargets = navigationConfig.navigationTargets
        .map((NavigationTarget navigationTarget) => NavigationTarget(
              title: navigationTarget.title,
              path: navigationTarget.path,
              contentPane: navigationTarget.contentPane,
              destination: navigationTarget.destination,
              navigationTabs: navigationTarget.navigationTabs == null ? null : List<NavigationTab>.from(navigationTarget.navigationTabs!),
              roles: navigationTarget.roles,
              public: navigationTarget.public,
              private: navigationTarget.private,
              landingPage: navigationTarget.landingPage,
            ))
        .toList();

    return NavigationConfig(
      emptyPage: navigationConfig.emptyPage,
      errorPage: navigationConfig.errorPage,
      navigationTargets: navigationTargets,
      signInConfig: navigationConfig.signInConfig,
      waitPage: navigationConfig.waitPage,
    );
  }
}
