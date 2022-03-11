import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({
    Key? key,
    required this.navigationTarget,
    required this.goRouterState,
  }) : super(key: key);
  final NavigationTarget navigationTarget;
  final GoRouterState goRouterState;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(vsync: this, length: 0);
  late NavigationTab navigationTab;

  @override
  Widget build(BuildContext context) {
    TabBar? _tabBar = null;
    Widget? _contentBody; //= widget.navigationTarget.contentPane;
    Widget? _scaffoldBody = null;

    if (widget.navigationTarget.navigationTabs != null) {
      //Process the tabbar;
      _tabBar = TabBar(
        tabs: widget.navigationTarget.navigationTabs!
            .map((NavigationTab navigationTab) => Tab(
                  key: Key(navigationTab.path),
                  text: navigationTab.title,
                ))
            .toList(),
        controller: _tabController,
        onTap: (index) => _tabBarTap(context, index),
      );

      if (navigationTab.contentPane != null) {
        _contentBody = navigationTab.contentPane;
      } else {
        _contentBody = EmptyScreen();
      }
    } else {
      //Process from a screen without tabs
      if (widget.navigationTarget.contentPane != null) {
        _contentBody = widget.navigationTarget.contentPane;
      } else {
        _contentBody = EmptyScreen();
      }
    }

    //Prevent content body from being empty.
    _contentBody = _contentBody != null ? _contentBody : EmptyScreen();
    _scaffoldBody = _contentBody;
    return Scaffold(
      appBar: _tabBar,
      body: _scaffoldBody,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.navigationTarget.navigationTabs != null) {
      String currentTab = widget.goRouterState.subloc.split('/').last;

      List<NavigationTab> navigationTabs = widget.navigationTarget.navigationTabs!;
      navigationTab = navigationTabs.firstWhere((NavigationTab navigationTab) => navigationTab.path == currentTab);

      int currentIndex = widget.navigationTarget.navigationTabs!.map((NavigationTab navigationTab) => navigationTab.path).toList().indexOf(currentTab);
      _tabController = TabController(
        vsync: this,
        length: widget.navigationTarget.navigationTabs!.length,
        initialIndex: currentIndex < 0 ? 0 : currentIndex,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _tabBarTap(BuildContext context, int index) {
    context.go('/${widget.navigationTarget.path}/${widget.navigationTarget.navigationTabs![index].path}');
  }
}
