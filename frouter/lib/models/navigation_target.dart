import 'package:flutter/material.dart';
import 'models.dart';

class NavigationTarget {
  final Widget? contentPane;

  final String title;
  final String path;
  final Destination? destination;
  final List<String>? roles;
  final List<NavigationTab>? navigationTabs;
  final bool public;
  final bool landingPage;

  NavigationTarget({
    required this.title,
    required this.path,
    this.contentPane,
    this.destination,
    this.navigationTabs,
    this.roles,
    this.public = false,
    this.landingPage = false,
  }); //: assert(contentPane == null && navigationTabs == null, "NavigationTarget: '/${path}' Either contentPane or navigationTabs must not be null");
}
