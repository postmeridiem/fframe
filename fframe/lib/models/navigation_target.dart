part of fframe;

class NavigationTarget {
  final Widget? contentPane;

  final String title;
  late String path;
  final Destination? destination;
  final List<String>? roles;
  final List<NavigationTab>? navigationTabs;
  final bool public;
  final bool private;
  final bool landingPage;

  NavigationTarget({
    required this.title,
    required this.path,
    this.contentPane,
    this.destination,
    this.navigationTabs,
    this.roles,
    this.public = false,
    this.private = true,
    this.landingPage = false,
  }); // : assert(contentPane == null && navigationTabs == null, "NavigationTarget: '$path' Either contentPane or navigationTabs must be null: ${contentPane == null} ${navigationTabs == null}"),
  //    assert(navigationTabs != null && roles != null, "NavigationTarget: '$path' Do not assign roles when tabs are determined. The roles are derived from the tabs");
}
