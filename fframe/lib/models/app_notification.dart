part of '../../fframe.dart';

class FframeNotification extends ChangeNotifier {
  FframeNotification({
    this.id,
    this.notificationTime,
    required this.reporter,
    required this.messageTitle,
    this.type = "notification",
    this.messageSubtitle,
    this.messageBody,
    this.contextLinks,
    this.seen = false,
    this.read = false,
    this.deleted = false,
    this.firestoreTTL,
  });

  final String? id;
  final Timestamp? notificationTime;
  final String reporter;
  final String type;
  final String messageTitle;
  final String? messageSubtitle;
  final String? messageBody;
  final List<Map>? contextLinks;

  final bool seen;
  final bool read;
  final bool deleted;
  final Timestamp? firestoreTTL;

  factory FframeNotification.fromFirestore({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? snapshotOptions,
  }) {
    Map<String, dynamic> json = snapshot.data()!;
    FframeNotification notification = FframeNotification(
      id: snapshot.id,
      notificationTime: json['notificationTime'] ?? Timestamp.now,
      reporter: json['reporter'] ?? "",
      type: json['type'] ?? "",
      messageTitle: json['messageTitle'] ?? "",
      messageSubtitle: json['messageSubtitle'] ?? "",
      messageBody: json['messageBody'] ?? "",
      contextLinks: json['contextLinks'] ?? [],
      seen: json['seen'],
      read: json['read'],
      deleted: json['deleted'],
      firestoreTTL: json['firestoreTTL'] ??
          Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 30)),
          ),
    );

    return FframeNotification(
      notificationTime: notification.notificationTime,
      reporter: notification.reporter,
      type: notification.type,
      messageTitle: notification.messageTitle,
      messageSubtitle: notification.messageSubtitle,
      messageBody: notification.messageBody,
      contextLinks: notification.contextLinks,
      seen: notification.seen,
      read: notification.read,
      deleted: notification.deleted,
      firestoreTTL: notification.firestoreTTL,
    );
  }
}
