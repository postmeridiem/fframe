import 'models.dart';

class NavigationConfig {
  final List<NavigationTarget> navigationTargets;
  final SignInConfig signInConfig;
  final NavigationTarget errorPage;
  NavigationConfig({
    required this.signInConfig,
    required this.navigationTargets,
    required this.errorPage,
  });

  factory NavigationConfig.clone(NavigationConfig navigationConfig) {
    return NavigationConfig(
      errorPage: navigationConfig.errorPage,
      navigationTargets: List<NavigationTarget>.from(navigationConfig.navigationTargets),
      signInConfig: navigationConfig.signInConfig,
    );
  }
}
