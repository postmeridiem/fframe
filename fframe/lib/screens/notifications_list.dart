import 'dart:ui_web' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

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

final Map<String, String?> _photoCache = {}; // Global cache

class NotificationTile extends StatefulWidget {
  final FframeNotification notification;
  final String userId;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.userId,
  });

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    _loadReporterPhoto();
  }

  Future<void> _loadReporterPhoto() async {
    final email = widget.notification.reporter;

    if (_photoCache.containsKey(email)) {
      photoUrl = _photoCache[email];
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data();
        final fetchedUrl = userData['photoURL'];

        _photoCache[email] = fetchedUrl;
        if (fetchedUrl != null && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                photoUrl = fetchedUrl;
              });
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading avatar: $e");
    }
  }

  Future<void> _toggleRead(bool value) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('notifications').doc(widget.notification.id);

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

  String _timeAgoFormat(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget _buildAvatar() {
    if (photoUrl != null) {
      if (kIsWeb) {
        final viewType = 'img-${photoUrl.hashCode}';
        // ignore: undefined_prefixed_name
        ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
          final img = html.ImageElement()
            ..src = photoUrl!
            ..style.borderRadius = '50%'
            ..style.objectFit = 'cover'
            ..width = 36
            ..height = 36;
          return img;
        });

        return SizedBox(
          width: 36,
          height: 36,
          child: HtmlElementView(viewType: viewType),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: photoUrl!,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 18,
            backgroundImage: imageProvider,
            backgroundColor: Colors.transparent,
          ),
          placeholder: (context, url) => CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.person, size: 18, color: Colors.white),
          ),
          errorWidget: (context, url, error) => _fallbackInitialsAvatar(),
        );
      }
    }

    return _fallbackInitialsAvatar();
  }

  Widget _fallbackInitialsAvatar() {
    final email = widget.notification.reporter;
    final namePart = email.split('@').first;
    final parts = namePart.split(RegExp(r'[._]'));
    final initials = parts.take(2).map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').join();

    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.blueGrey.shade700,
      child: Text(
        initials,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = widget.notification.notificationTime?.toDate();
    final timeAgo = timestamp != null ? _timeAgoFormat(timestamp) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.notification.messageTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: widget.notification.read ? Colors.grey[400] : Colors.white,
                  ),
                ),
                if (widget.notification.messageSubtitle?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      widget.notification.messageSubtitle!,
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ),
                if (widget.notification.messageBody?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.notification.messageBody!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                if (widget.notification.contextLinks != null && widget.notification.contextLinks!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: widget.notification.contextLinks!
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
                      onTap: () => _toggleRead(!widget.notification.read),
                      child: Tooltip(
                        message: widget.notification.read ? 'Mark as unread' : 'Mark as read',
                        child: Icon(
                          widget.notification.read ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined,
                          color: Colors.blueAccent,
                          size: 18,
                        ),
                      ),
                    ),
                    if (!widget.notification.read)
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
}
