import 'package:flutter/material.dart';
import 'models.dart';

class NavigationTab extends NavigationTarget {
  NavigationTab({
    required String title,
    required String path,
    required Widget contentPane,
    List<String>? roles,
  }) :
        // assert(contentPane == null, "NavigationTab: '/${path}' contentPane must not be null"),
        super(
          title: title,
          path: path,
          contentPane: contentPane,
          roles: roles,
        );

  late NavigationTarget parentTarget;
}
