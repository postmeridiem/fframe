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

class _NotificationButtonState extends State<NotificationButton> {
  OverlayEntry? _overlayEntry;

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + renderBox.size.height + 8,
        right: 16,
        width: 400,
        height: 500,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: _toggleOverlay,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: NotificationsList(userId: widget.userId),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
