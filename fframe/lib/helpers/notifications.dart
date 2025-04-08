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
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  late OverlayState overlayState;
  late OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {},
    );
  }
}
