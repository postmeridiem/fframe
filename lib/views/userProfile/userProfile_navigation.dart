import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/userProfile/userProfile.dart';

final userProfileNavigationTargets = NavigationTarget(
  path: "profile",
  title: "User Profile",
  contentPane: UserProfile(),
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.person_outline),
    label: Text('Profile Page'),
  ),
);
