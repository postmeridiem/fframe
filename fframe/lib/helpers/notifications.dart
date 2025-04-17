part of '../../fframe.dart';

class FframeNotifications {
  static final FframeNotifications instance = FframeNotifications._internal();

// stores if the notifications system is enabled
  late bool enabled;

  FframeNotifications._internal();

  factory FframeNotifications({required bool notficationSystemEnabled}) {
    instance.enabled = notficationSystemEnabled;

    return instance;
  }

  static void enableNotificationSystem() {
    FframeNotifications.instance.enabled = true;
  }

  static void disableNotificationSystem() {
    FframeNotifications.instance.enabled = false;
  }

  static void sendNotificationsToEmails({required List<String> emailAddresses, required FframeNotification notification}) {
    Console.log("creating notification ${notification.messageTitle}", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
  }

  static void sendNotificationsToUUIDs({required List<String> uuids, required FframeNotification notification}) {
    Console.log("creating notification ${notification.messageTitle}", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
    //  FframeNotifications.sendNotificationsToEmails(emailAddresses: emailAddresses, notification: notification);
  }
}

class NotificationButton extends StatefulWidget {
  final String userId;

  const NotificationButton({super.key, required this.userId});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      _controller.forward();
    } else {
      _controller.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  OverlayEntry _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _toggleOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              top: offset.dy + renderBox.size.height + 8,
              right: MediaQuery.of(context).size.width - (offset.dx + renderBox.size.width),
              width: 400,
              child: Material(
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: _scaleAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    alignment: Alignment.topRight,
                    child: Material(
                      elevation: 12,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      color: Theme.of(context).cardColor,
                      child: SizedBox(
                        height: 500,
                        child: NotificationsList(userId: widget.userId),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications),
      onPressed: _toggleOverlay,
    );
  }
}
