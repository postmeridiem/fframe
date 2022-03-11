import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/runConfigs/runConfig.dart';

final runConfigNavigationTargets = NavigationTarget(
  path: "runconfigs",
  title: "Run Configurations",
  contentPane: runConfigScreen(),
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.schedule),
    label: Text('Run Configuration'),
  ),
  roles: ['user'],
);
