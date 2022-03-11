import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/clients/clients.dart';

final clientNavigationTargets = NavigationTarget(
  path: "clients",
  title: "Clients",
  navigationTabs: <NavigationTab>[
    NavigationTab(
      contentPane: clientScreen(active: true),
      title: "Active",
      path: "active",
    ),
    NavigationTab(
      contentPane: clientScreen(active: false),
      title: "Inactive",
      path: "inactive",
    )
  ],
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.business_rounded),
    label: Text('Clients'),
  ),
  roles: ['user'],
);
