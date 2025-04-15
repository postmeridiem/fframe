import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsList extends StatelessWidget {
  final String userId;

  const NotificationsList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(userId).collection("notifications").orderBy("notificationTime", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No notifications"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final notification = FframeNotification.fromFirestore(snapshot: docs[index] as DocumentSnapshot<Map<String, dynamic>>);

            return _NotificationTile(notification: notification);
          },
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final FframeNotification notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final timestamp = notification.notificationTime?.toDate();
    final timeAgo = timestamp != null ? "${timestamp.difference(DateTime.now()).inDays.abs()}d ago" : "";

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.notifications)),
      title: Text(notification.messageTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notification.messageSubtitle != null && notification.messageSubtitle!.isNotEmpty) Text(notification.messageSubtitle!, style: const TextStyle(fontSize: 13)),
          if (notification.messageBody != null && notification.messageBody!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(notification.messageBody!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (timeAgo.isNotEmpty) Text(timeAgo, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          if (!notification.read)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(Icons.circle, size: 8, color: Colors.blueAccent),
            ),
        ],
      ),
      onTap: () {
        // TODO: Mark as read / navigate to details / open link
      },
    );
  }
}
