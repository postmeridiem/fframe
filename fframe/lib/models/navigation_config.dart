part of '../../fframe.dart';

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

  /// Framework-owned target shown when a signed-in user has no resolvable
  /// landing page (no `landingPage` target is accessible to their role(s)).
  /// Rendered instead of a blank/grey screen.
  static NavigationTarget get noLandingPageTarget => NavigationTarget(
        title: L10n.string("nav_no_landing_page_title", placeholder: "No landing page configured", namespace: "fframe"),
        path: "/fframe-no-landing-page",
        contentPane: FMessagePage(
          icon: Icons.home_outlined,
          title: L10n.string("nav_no_landing_page_title", placeholder: "No landing page configured", namespace: "fframe"),
          message: L10n.string(
            "nav_no_landing_page_message",
            placeholder: "No landing page has been configured for your account. Please contact your administrator.",
            namespace: "fframe",
          ),
        ),
      );

  /// Framework-owned target shown when a user navigates to a page that exists
  /// but their role(s) do not grant access to it (e.g. a forwarded/deep link).
  static NavigationTarget get noAccessTarget => NavigationTarget(
        title: L10n.string("nav_no_access_title", placeholder: "No access", namespace: "fframe"),
        path: "/fframe-no-access",
        contentPane: FMessagePage(
          icon: Icons.lock_outline,
          title: L10n.string("nav_no_access_title", placeholder: "No access", namespace: "fframe"),
          message: L10n.string(
            "nav_no_access_message",
            placeholder: "You don't have access rights for this page. Please contact your administrator.",
            namespace: "fframe",
          ),
        ),
      );
}
