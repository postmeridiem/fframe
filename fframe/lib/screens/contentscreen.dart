import 'package:fframe/fframe.dart';
import 'package:fframe/providers/state_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentScreen extends ConsumerWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TargetState targetState = ref.watch(targetStateProvider);

    if ((targetState.navigationTarget is NavigationTab)) {
      return const TabbbedContentScreen();
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey("navTarget_${targetState.navigationTarget.title}"),
        child: targetState.navigationTarget.contentPane,
      ),
    );
  }
}

class TabbbedContentScreen extends StatefulWidget {
  const TabbbedContentScreen({Key? key}) : super(key: key);

  @override
  State<TabbbedContentScreen> createState() => _TabbbedContentScreenState();
}

class _TabbbedContentScreenState extends State<TabbbedContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


// class ContentScreen extends StatefulWidget {
//   const ContentScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ContentScreen> createState() => _ContentScreenState();
// }

// class _ContentScreenState extends State<ContentScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController = TabController(vsync: this, length: 0);
//   late NavigationTab navigationTab;

//   @override
//   Widget build(BuildContext context) {
//     NavigationTarget currentTarget = FRouter.of(context).currentTarget;

//     int currentIndex = FRouter.of(context).navigationTabs.map((NavigationTab navigationTab) => navigationTab.path).toList().indexOf(currentTarget.path);
//     // _tabController = TabController(
//     //   vsync: this,
//     //   length: FRouter.of(context).navigationTabs.length,
//     //   initialIndex: currentIndex < 0 ? 0 : currentIndex,
//     // );
//     _tabController.length = FRouter.of(context).navigationTabs.length;

//     TabBar? _tabBar = FRouter.of(context).hasTabs
//         ? TabBar(
//             tabs: FRouter.of(context)
//                 .navigationTabs
//                 .map((NavigationTab navigationTab) => Tab(
//                       key: Key(navigationTab.path),
//                       text: navigationTab.title,
//                     ))
//                 .toList(),
//             controller: _tabController,
//             onTap: (index) => _tabBarTap(context, index),
//           )
//         : null;

//     return Scaffold(
//       primary: false,
//       appBar: FRouter.of(context).hasTabs ? _tabBar : null,
//       body: const ContentPane(),
//     );

//     // } else {
//     //   return const ContentPane();
//     // }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _tabBarTap(BuildContext context, int index) {
//     // context.go('/${widget.navigationTarget.path}/${widget.navigationTarget.navigationTabs![index].path}');
//   }
// }