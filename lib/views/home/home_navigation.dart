import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/home/home.dart';

final homeNavigationTargets = NavigationTarget(
  path: "home",
  title: "Home",
  contentPane: HomeScreen(),
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.home),
    label: Text('Home'),
  ),
  roles: ['home'],
);
