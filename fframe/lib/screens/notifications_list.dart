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
  bool onlyShowUnread = false;

  @override
  void initState() {
    super.initState();
    _markAllAsSeen();
  }

  Future<void> _markAllAsSeen() async {
    final unseen = await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('notifications').where('seen', isEqualTo: false).get();

    for (final doc in unseen.docs) {
      doc.reference.update({'seen': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsBase = FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('notifications');

    final query = onlyShowUnread ? notificationsBase.where('read', isEqualTo: false).orderBy('notificationTime', descending: true) : notificationsBase.orderBy('notificationTime', descending: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Text(
                'Only show unread',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              Switch(
                value: onlyShowUnread,
                onChanged: (value) {
                  setState(() {
                    onlyShowUnread = value;
                  });
                },
                activeColor: Colors.blueAccent,
              ),
            ],
          ),
        ),

        // Notification list
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error loading notifications:\n${snapshot.error}",
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Center(
                  child: Text("No notifications", style: TextStyle(color: Colors.white54)),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
          ),
        ),
      ],
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  Icon _getLinkIcon(String href) {
    if (href.contains('atlassian')) return const Icon(Icons.bug_report, size: 14, color: Colors.blueAccent);
    if (href.contains('github')) return const Icon(Icons.code, size: 14, color: Colors.blueAccent);
    return const Icon(Icons.link, size: 14, color: Colors.blueAccent);
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

                // 🔗 Context links with icons
                if (notification.contextLinks != null && notification.contextLinks!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: notification.contextLinks!
                          .map((link) => TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () => _launchUrl(link['href']),
                                icon: _getLinkIcon(link['href']),
                                label: Text(
                                  link['label'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ))
                          .toList(),
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
