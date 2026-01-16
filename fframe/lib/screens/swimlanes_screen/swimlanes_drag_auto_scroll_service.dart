part of 'package:fframe/fframe.dart';

/// Service that handles automatic horizontal scrolling when dragging
/// cards near the edges of the swimlanes viewport.
///
/// This service monitors pointer position during drag operations and
/// triggers smooth scrolling when the cursor approaches the viewport edges.
class DragAutoScrollService {
  ScrollController? _horizontalController;
  Timer? _scrollTimer;
  double _currentScrollDelta = 0;

  /// Distance from viewport edge (in pixels) that triggers auto-scroll.
  static const double edgeThreshold = 80.0;

  /// Maximum scroll speed in pixels per tick.
  static const double maxScrollSpeed = 15.0;

  /// Interval between scroll ticks (~60fps).
  static const Duration _scrollInterval = Duration(milliseconds: 16);

  /// Attaches a horizontal ScrollController to enable auto-scrolling.
  void attachHorizontalController(ScrollController controller) {
    _horizontalController = controller;
  }

  /// Detaches the ScrollController and stops any active scrolling.
  void detachHorizontalController() {
    _stopScrolling();
    _horizontalController = null;
  }

  /// Called during drag to update scroll behavior based on pointer position.
  ///
  /// [globalPosition] is the pointer's global position from PointerMoveEvent.
  /// [context] should be the BuildContext of the scrollable viewport.
  void onDragUpdate(Offset globalPosition, BuildContext context) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || _horizontalController == null) return;

    final localPosition = box.globalToLocal(globalPosition);
    final viewportWidth = box.size.width;

    double scrollDelta = 0;

    // Check left edge - scroll left (negative delta)
    if (localPosition.dx < edgeThreshold) {
      final proximity = (edgeThreshold - localPosition.dx) / edgeThreshold;
      scrollDelta = -maxScrollSpeed * proximity;
    }
    // Check right edge - scroll right (positive delta)
    else if (localPosition.dx > viewportWidth - edgeThreshold) {
      final proximity =
          (localPosition.dx - (viewportWidth - edgeThreshold)) / edgeThreshold;
      scrollDelta = maxScrollSpeed * proximity;
    }

    if (scrollDelta != 0) {
      _currentScrollDelta = scrollDelta;
      _startScrolling();
    } else {
      _stopScrolling();
    }
  }

  void _startScrolling() {
    // Only start a new timer if one isn't already running
    if (_scrollTimer != null) return;

    _scrollTimer = Timer.periodic(_scrollInterval, (_) {
      if (_horizontalController == null ||
          !_horizontalController!.hasClients) {
        _stopScrolling();
        return;
      }

      final currentOffset = _horizontalController!.offset;
      final maxOffset = _horizontalController!.position.maxScrollExtent;

      final newOffset =
          (currentOffset + _currentScrollDelta).clamp(0.0, maxOffset);

      // Only scroll if we're not at the boundary
      if (newOffset != currentOffset) {
        _horizontalController!.jumpTo(newOffset);
      }
    });
  }

  void _stopScrolling() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
    _currentScrollDelta = 0;
  }

  /// Called when drag operation ends to clean up scrolling state.
  void onDragEnd() {
    _stopScrolling();
  }

  /// Disposes of all resources. Call when the service is no longer needed.
  void dispose() {
    _stopScrolling();
    _horizontalController = null;
  }
}
