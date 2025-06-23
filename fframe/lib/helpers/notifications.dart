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

  static Future<void> sendNotificationsToEmails({required List<String> emailAddresses, required FframeNotification notification}) async {
    Console.log("Sending notification ${notification.messageTitle} to $emailAddresses", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);

    if (emailAddresses.isEmpty) {
      Console.log("No email addresses provided.", scope: "fframeLog.FframeNotifications", level: LogLevel.prod);
      return;
    }

    final firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();
    int batchCount = 0;

    for (String email in emailAddresses) {
      try {
        // Find user by email
        final userQuerySnapshot = await firestore.collection('users').where('email', isEqualTo: email).limit(1).get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          final userId = userQuerySnapshot.docs.first.id;
          final notificationRef = firestore.collection('users').doc(userId).collection('notifications').doc();

          // Use a copy of the notification to ensure 'seen' and 'read' are false for new notifications
          // and to set a fresh notificationTime and firestoreTTL
          final FframeNotification newNotification = FframeNotification(
            reporter: notification.reporter,
            messageTitle: notification.messageTitle,
            type: notification.type,
            messageSubtitle: notification.messageSubtitle,
            messageBody: notification.messageBody,
            contextLinks: notification.contextLinks,
            seen: false, // Ensure new notifications are unseen
            read: false, // Ensure new notifications are unread
            notificationTime: notification.notificationTime ?? Timestamp.now(), // Set current time for the notification
            firestoreTTL: notification.firestoreTTL ?? Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))), // Set TTL based on creation time
          );

          batch.set(notificationRef, newNotification.toFirestore());
          batchCount++;

          Console.log("Notification queued for $email (User ID: $userId)", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);

          // Firestore batch limit is 500 operations
          if (batchCount >= 499) {
            // Commit a bit before the limit to be safe
            await batch.commit();
            batch = firestore.batch(); // Start a new batch
            batchCount = 0;
            Console.log("Committed a batch of notifications.", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
          }
        } else {
          Console.log("User not found for email: $email", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
        }
      } catch (e) {
        Console.log("Error sending notification to $email: $e", scope: "fframeLog.FframeNotifications", level: LogLevel.prod);
      }
    }

    // Commit any remaining operations in the batch
    if (batchCount > 0) {
      try {
        await batch.commit();
        Console.log("Committed final batch of notifications.", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
      } catch (e) {
        Console.log("Error committing final batch: $e", scope: "fframeLog.FframeNotifications", level: LogLevel.prod);
      }
    }
    Console.log("Finished sending notifications for: ${notification.messageTitle}", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
  }

  static Future<void> sendNotificationsToUUIDs({required List<String> uuids, required FframeNotification notification}) async {
    Console.log("Sending notification ${notification.messageTitle} to UUIDs: $uuids", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);

    if (uuids.isEmpty) {
      Console.log("No UUIDs provided.", scope: "fframeLog.FframeNotifications", level: LogLevel.prod);
      return;
    }

    final firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();
    int batchCount = 0;

    for (String userId in uuids) {
      try {
        // Check if the user document exists to avoid creating orphaned notification documents
        final userDoc = await firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          final notificationRef = firestore.collection('users').doc(userId).collection('notifications').doc();

          // Use a copy of the notification to ensure 'seen' and 'read' are false for new notifications
          // and to set a fresh notificationTime and firestoreTTL
          final FframeNotification newNotification = FframeNotification(
            reporter: notification.reporter,
            messageTitle: notification.messageTitle,
            type: notification.type,
            messageSubtitle: notification.messageSubtitle,
            messageBody: notification.messageBody,
            contextLinks: notification.contextLinks,
            seen: false, // Ensure new notifications are unseen
            read: false, // Ensure new notifications are unread
            notificationTime: notification.notificationTime ?? Timestamp.now(), // Set current time for the notification
            firestoreTTL: notification.firestoreTTL ?? Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))), // Set TTL based on creation time
          );

          batch.set(notificationRef, newNotification.toFirestore());
          batchCount++;

          Console.log("Notification queued for User ID: $userId", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);

          // Firestore batch limit is 500 operations
          if (batchCount >= 499) {
            // Commit a bit before the limit to be safe
            await batch.commit();
            batch = firestore.batch(); // Start a new batch
            batchCount = 0;
            Console.log("Committed a batch of notifications.", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
          }
        } else {
          Console.log("User not found for UUID: $userId. Skipping notification.", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
        }
      } catch (e) {
        Console.log("Error processing notification for User ID $userId: $e", scope: "fframeLog.FframeNotifications", level: LogLevel.prod);
      }
    }

    // Commit any remaining operations in the batch
    if (batchCount > 0) {
      try {
        await batch.commit();
        Console.log("Committed final batch of notifications.", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
      } catch (e) {
        Console.log("Error committing final batch: $e", scope: "fframeLog.FframeNotifications", level: LogLevel.prod);
      }
    }
    Console.log("Finished sending notifications for: ${notification.messageTitle} to UUIDs", scope: "fframeLog.FframeNotifications", level: LogLevel.dev);
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('notifications').where('seen', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        int unseenCount = 0;
        if (snapshot.hasData) {
          unseenCount = snapshot.data!.docs.length;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: _toggleOverlay,
            ),
            if (unseenCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      unseenCount > 9 ? '9+' : unseenCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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
}
