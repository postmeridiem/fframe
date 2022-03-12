import 'package:flutter/material.dart';
import 'package:fframe/models/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

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
    return Card(
        child: Row(
      children: [
        Flexible(
          child: MainCanvas(context, suggestion),
        ),
        SizedBox(
          width: 250,
          child: ContextCanvas(context, suggestion),
        ),
      ],
    )
        // child: Column(
        //   // crossAxisAlignment: CrossAxisAlignment.start,
        //   // mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     //   SizedBox(
        //     //     height: 100,
        //     //     child: HeaderCanvas(context, suggestion),
        //     //   ),
        //     //   Divider(),
        //     Expanded(child: ContentCanvas(context, suggestion)),
        //   ],
        // ),
        );
  }
}

class ContentCanvas extends StatelessWidget {
  const ContentCanvas(BuildContext context, this.suggestion);
  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: MainCanvas(context, suggestion),
        ),
        SizedBox(
          width: 250,
          child: ContextCanvas(context, suggestion),
        ),
      ],
    );
  }
}

class MainCanvas extends StatelessWidget {
  const MainCanvas(BuildContext context, this.suggestion);
  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        primary: false,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                primary: false,
                title: DocumentTitle(context, suggestion.name!),
                floating: true,
                pinned: false,
                snap: true,
                automaticallyImplyLeading: false,
                bottom: new TabBar(
                  tabs: <Tab>[
                    Tab(
                        icon: Icon(
                      Icons.directions_car,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.directions_transit,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.directions_bike,
                    )),
                  ], // <-- total of 2 tabs
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Container(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Album'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Album'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Album'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Album'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Album'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Album'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Album'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Album'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phonelast'),
                    ),
                  ],
                ),
              ),
              SecondTab(),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            ActionButton(
              onPressed: () => {},
              icon: Icon(
                Icons.close,
                color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
            ActionButton(
              onPressed: () => {},
              icon: Icon(
                Icons.save,
                color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
            ActionButton(
              onPressed: () => {},
              icon: Icon(
                Icons.add,
                color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondTab extends StatelessWidget {
  const SecondTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Placeholder(fallbackHeight: 2000),
      ),
    );
  }
}

class ContextCanvas extends StatelessWidget {
  const ContextCanvas(BuildContext context, this.suggestion);
  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('context widget'),
                // Expanded(child: IgnorePointer()),
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
  const DocumentTitle(BuildContext context, this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${name.toUpperCase()}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.secondary,
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
