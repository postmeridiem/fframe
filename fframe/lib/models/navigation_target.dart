part of '../../fframe.dart';

class NavigationTarget {
  final String title;
  late String path;
  final Destination? destination;
  final List<String>? roles;
  final List<NavigationTab>? navigationTabs;
  final Widget? contentPane;
  final bool public;
  final bool private;
  final bool landingPage;
  final bool profilePage;

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
    this.profilePage = false,
  }) : assert(!(contentPane != null && navigationTabs != null), "NavigationTarget: '$title' Either contentPane or navigationTabs must be null.");
}
