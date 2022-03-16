import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fframe_demo/models/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fframe_demo/constants/fonts.dart';
import 'package:fframe_demo/helpers/fillers.dart';

class SuggestionDocument extends StatelessWidget {
  const SuggestionDocument({
    required this.suggestion,
    required this.documentReference,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final Suggestion suggestion;
  final DocumentReference documentReference;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: MainCanvas(suggestion: suggestion),
        ),
        SizedBox(
          width: 250,
          child: ContextCanvas(suggestion: suggestion),
        ),
      ],
    );
  }
}

// class ContentCanvas extends StatelessWidget {
//   const ContentCanvas({Key? key, required this.suggestion}) : super(key: key);

//   final Suggestion suggestion;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Flexible(
//           child: MainCanvas(suggestion: suggestion),
//         ),
//         SizedBox(
//           width: 250,
//           child: ContextCanvas(suggestion: suggestion),
//         ),
//       ],
//     );
//   }
// }

class DocumentTab {
  final Tab tab;
  final Widget child;

  DocumentTab({required this.tab, required this.child});
}

class MainCanvas extends StatelessWidget {
  MainCanvas({Key? key, required this.suggestion}) : super(key: key);

  final Suggestion suggestion;

  final List<DocumentTab> documentTabs = [
    DocumentTab(
      tab: const Tab(
        text: "A Long List",
        icon: Icon(
          Icons.view_list,
        ),
      ),
      child: const ALongListView(),
    ),
    DocumentTab(
      tab: const Tab(
        text: "Placeholder",
        icon: Icon(
          Icons.settings_overscan,
        ),
      ),
      child: const SecondTab(),
    ),
    DocumentTab(
      tab: const Tab(
        text: "Ok or Not?",
        icon: Icon(
          Icons.flaky,
        ),
      ),
      child: const Icon(Icons.check),
    ),
  ];
  final List<ActionButton> actionButtons = [
    ActionButton(
      onPressed: () => {},
      icon: const Icon(
        Icons.close,
        // color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
      ),
    ),
    ActionButton(
      onPressed: () => {},
      icon: const Icon(
        Icons.save,
        // color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
      ),
    ),
    ActionButton(
      onPressed: () => {},
      icon: const Icon(
        Icons.add,
        // color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        primary: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                primary: false,
                title: DocumentTitle(name: suggestion.name!),
                floating: true,
                pinned: false,
                snap: true,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                bottom: TabBar(
                  tabs: documentTabs.map((documentTab) => documentTab.tab).toList(),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: documentTabs.map((documentTab) => documentTab.child).toList(),
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: actionButtons,
        ),
      ),
    );
  }
}

class SecondTab extends StatelessWidget {
  const SecondTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: SizedBox(
        child: Placeholder(fallbackHeight: 2000),
      ),
    );
  }
}

class ContextCanvas extends StatelessWidget {
  const ContextCanvas({Key? key, required this.suggestion}) : super(key: key);
  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                ContextWidgetCard(title: "title 1 number"),
                ContextWidgetCard(title: "second"),
                ContextWidgetCard(title: "1 a 2 b 3 c 4 d"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class HeaderCanvas extends StatelessWidget {
//   const HeaderCanvas(BuildContext context, this.suggestion);
//   final Suggestion suggestion;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               DocumentTitle(context, suggestion.name!),
//               HeaderControlWidget(context, suggestion),
//             ],
//           ),
//         ),
//         SizedBox(
//           width: 250,
//           height: 20,
//         ),
//       ],
//     );
//   }
// }

// class HeaderControlWidget extends StatelessWidget {
//   const HeaderControlWidget(BuildContext context, this.suggestion);
//   final Suggestion suggestion;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "created on ${suggestion.creationDate}",
//                 style: TextStyle(fontSize: 10),
//                 textAlign: TextAlign.left,
//               ),
//               Text(
//                 "by ${suggestion.createdBy}",
//                 style: TextStyle(fontSize: 10),
//                 textAlign: TextAlign.left,
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: Alignment.bottomRight,
//               child: ButtonBar(
//                 children: <Widget>[
//                   OutlinedButton(
//                     child: Text('Save'),
//                     onPressed: () {},
//                   ),
//                   OutlinedButton(
//                     child: Text('Reset'),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class DocumentTitle extends StatelessWidget {
  const DocumentTitle({Key? key, required, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0; i < count; i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.coffee_maker_outlined),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.primaryContainer,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.primaryContainer,
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    Key? key,
    required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}

class ContextWidgetCard extends StatelessWidget {
  const ContextWidgetCard({Key? key, context, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Column(children: [
            Text(title,
                style: TextStyle(
                  fontFamily: mainFontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )),
            Divider(color: Theme.of(context).colorScheme.onBackground),
            Text(
              "injected widget goes here",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
