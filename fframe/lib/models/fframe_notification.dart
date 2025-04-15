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
  final List<Map<String, dynamic>>? contextLinks;

  final bool seen;
  final bool read;
  final bool deleted;
  final Timestamp? firestoreTTL;

  factory FframeNotification.fromFirestore({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? snapshotOptions,
  }) {
    final json = snapshot.data()!;

    List<Map<String, dynamic>>? parsedContextLinks;
    if (json['contextLinks'] is List) {
      parsedContextLinks = (json['contextLinks'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }

    return FframeNotification(
      id: snapshot.id,
      notificationTime: json['notificationTime'] ?? Timestamp.now(),
      reporter: json['reporter'] ?? "",
      type: json['type'] ?? "notification",
      messageTitle: json['messageTitle'] ?? "",
      messageSubtitle: json['messageSubtitle'] ?? "",
      messageBody: json['messageBody'] ?? "",
      contextLinks: parsedContextLinks ?? [],
      seen: json['seen'] ?? false,
      read: json['read'] ?? false,
      deleted: json['deleted'] ?? false,
      firestoreTTL: json['firestoreTTL'] ??
          Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 30)),
          ),
    );
  }
}
