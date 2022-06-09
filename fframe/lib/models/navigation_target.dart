// part of fframe;

// class NavigationTarget {
//   final Widget? contentPane;

//   final String title;
//   final String path;
//   final NavigationRailDestination? navigationRailDestination;
//   final List<String>? roles;
//   final List<NavigationTab>? navigationTabs;
//   final bool signInPage;

//   // GoRouterState? state;

//   NavigationTarget({
//     required this.title,
//     required this.path,
//     this.contentPane,
//     this.navigationRailDestination,
//     this.navigationTabs,
//     this.roles,
//     this.signInPage = false,
//   }); //: assert(contentPane == null && navigationTabs == null, "NavigationTarget: '/${path}' Either contentPane or navigationTabs must not be null");
// }

// class NavigationTab extends NavigationTarget {
//   NavigationTab({
//     required String title,
//     required String path,
//     required Widget contentPane,
//     List<String>? roles,
//     bool initialPath = false,
//     bool signInPath = false,
//     bool requiresSignIn = true,
//   }) :
//         // assert(contentPane == null, "NavigationTab: '/${path}' contentPane must not be null"),
//         super(
//           title: title,
//           path: path,
//           contentPane: contentPane,
//           roles: roles,
//         );
// }
