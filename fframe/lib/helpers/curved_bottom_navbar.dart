import 'package:fframe/controllers/navigation_state_controller.dart';
import 'package:fframe/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurvedBottomBar extends ConsumerStatefulWidget {
  const CurvedBottomBar({
    Key? key,
    this.child,
    this.iconButtons,
    this.floatingActionButton,
  }) : super(key: key);
  final List<IconButton>? iconButtons;
  final FloatingActionButton? floatingActionButton;
  final Widget? child;
  @override
  // _BottomNavBarV2State createState() => _BottomNavBarV2State();
  ConsumerState<CurvedBottomBar> createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends ConsumerState<CurvedBottomBar> {
  @override
  Widget build(BuildContext context) {
    SelectionState selectionState = ref.watch(navigationStateProvider).selectionState;
    // SelectionState selectionState = navigationState.selectionState;

    final Size size = MediaQuery.of(context).size;

    List<Widget>? _iconButtons;
    if (widget.iconButtons != null && selectionState.data != null) {
      _iconButtons = List<Widget>.from(widget.iconButtons!);
      if (widget.floatingActionButton != null) {
        if (_iconButtons.length % 2 != 0) {
          _iconButtons.add(const IgnorePointer());
        }

        _iconButtons.insert(
            _iconButtons.length ~/ 2,
            SizedBox(
              width: size.width * 0.20,
            ));
      }
    } else {
      _iconButtons = null;
    }

    return Scaffold(
      // backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children: [
          if (widget.child != null) widget.child!,
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 60,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (_iconButtons != null)
                    CustomPaint(
                      size: Size(size.width, 80),
                      painter: BNBCustomPainter(widget.floatingActionButton != null),
                    ),
                  if (widget.floatingActionButton != null)
                    Center(
                      heightFactor: 0.6,
                      child: widget.floatingActionButton,
                      // child: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.add), elevation: 0.1, onPressed: () {}),
                    ),
                  if (_iconButtons != null)
                    SizedBox(
                      width: size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _iconButtons,
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  BNBCustomPainter(this.hasFAB);
  final bool hasFAB;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    if (hasFAB) {
      path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
      path.arcToPoint(Offset(size.width * 0.60, 20), radius: const Radius.circular(20.0), clockwise: false);
      path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    }
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
