import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/runConfigs/runConfig.dart';
import 'package:fframe/views/signInPage/signInPage.dart';
import 'package:fframe/views/clients/clients.dart';
import 'package:fframe/views/users/user.dart';
import 'package:fframe/views/scratchpad/scratchpad.dart';
import 'package:fframe/views/configuration/configuration.dart';

//The order here reflects the order in the siderail.
// Omit the navigationRailDestination hide the item from the navigationrail.
final List<NavigationTarget> authenticatedNavigationTargets = [
  runConfigNavigationTargets,
  clientNavigationTargets,
  configurationNavigationTargets,
  scratchpadNavigationTargets,
  usersNavigationTargets,
];

final List<NavigationTarget> unAuthenticatedNavigationTargets = [
  signInPageNavigationTargets,
];
