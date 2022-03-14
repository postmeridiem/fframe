import 'package:flutter/material.dart';
import 'package:fframe/models/navigation_target.dart';
import 'package:fframe_demo/views/home/home.dart';

final homeNavigationTargets = NavigationTarget(
  path: "home",
  title: "Home",
  contentPane: const HomeScreen(),
  navigationRailDestination: const NavigationRailDestination(
    icon: Icon(Icons.home),
    label: Text('Home'),
  ),
  roles: ['home'],
);
