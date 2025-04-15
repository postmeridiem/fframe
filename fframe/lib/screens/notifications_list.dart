import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationsList extends StatefulWidget {
  final String userId;

  const NotificationsList({super.key, required this.userId});

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  @override
  void initState() {
    super.initState();
    _markAllAsSeen();
  }

  Future<void> _markAllAsSeen() async {
    final unseenNotifications = await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('notifications').where('seen', isEqualTo: false).get();

    for (final doc in unseenNotifications.docs) {
      doc.reference.update({'seen': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('notifications').orderBy('notificationTime', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text("No notifications")),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final notification = FframeNotification.fromFirestore(
              snapshot: doc as DocumentSnapshot<Map<String, dynamic>>,
            );

            return NotificationTile(
              notification: notification,
              userId: widget.userId,
            );
          },
        );
      },
    );
  }
}

class NotificationTile extends StatelessWidget {
  final FframeNotification notification;
  final String userId;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.userId,
  });

  Future<void> _toggleRead(bool value) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('notifications').doc(notification.id);

    await docRef.update({'read': value});
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = notification.notificationTime?.toDate();
    final timeAgo = timestamp != null ? timeAgoFormat(timestamp) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blueGrey.shade800,
            child: const Icon(Icons.notifications, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.messageTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: notification.read ? Colors.grey[400] : Colors.white,
                  ),
                ),
                if (notification.messageSubtitle?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      notification.messageSubtitle!,
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ),
                if (notification.messageBody?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      notification.messageBody!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      timeAgo,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Spacer(),

                    // Read/Unread toggle
                    GestureDetector(
                      onTap: () => _toggleRead(!notification.read),
                      child: Tooltip(
                        message: notification.read ? 'Mark as unread' : 'Mark as read',
                        child: Icon(
                          notification.read ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined,
                          color: Colors.blueAccent,
                          size: 18,
                        ),
                      ),
                    ),

                    if (!notification.read)
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(Icons.circle, size: 8, color: Colors.blueAccent),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String timeAgoFormat(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
