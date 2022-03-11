import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/signInPage/signInPage.dart';
import 'package:fframe/views/users/user.dart';
import 'package:fframe/views/suggestion/suggestion.dart';
//import 'package:fframe/views/scratchpad/scratchpad.dart';

//The order here reflects the order in the siderail.
// Omit the navigationRailDestination hide the item from the navigationrail.
final List<NavigationTarget> authenticatedNavigationTargets = [
  suggestionNavigationTargets,
  //scratchpadNavigationTargets,
  usersNavigationTargets,
];

final List<NavigationTarget> unAuthenticatedNavigationTargets = [
  signInPageNavigationTargets,
];
