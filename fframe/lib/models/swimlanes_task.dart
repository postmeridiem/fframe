part of fframe;

class SwimlanesTask extends ChangeNotifier {
  SwimlanesTask({
    this.id,
    this.snapshot,
    this.name,
    this.priority = 5,
    this.active,
    this.icon,
    this.color,
    this.status = "new",
    this.description,
    this.creationDate,
    this.createdBy,
    this.linkedPath,
    this.linkedDocumentId,
    this.assignedTo,
    this.assignmentTime,
    this.comments = const {},
    this.followers = const [],
    this.dueTime,
    this.saveCount = 0,
    // this.changeHistory,
  });

  /// SwimlanesTask class
  /// check [name] for the name
  ///
  /// this documentation is a lie
  ///
  /// =================
  ///
  /// [String] id - swimlane task id
  ///
  /// [String] name - name of the swimlane task
  ///
  /// [String] description - description of the swimlane task
  ///
  /// [int] priority - priority of the swimlane task
  ///
  /// [bool] active - is the swimlane task active
  ///
  /// [Icon] icon - task icon
  ///
  /// [Color] color - task color
  ///
  /// [Timestamp] creationDate - creation date of swimlane task
  ///
  /// [String] createdBy - creator of the swimlane task
  ///
  /// [String] assignedTo - person or role this is assigned to.
  ///
  /// [String] assignmentTime - the moment this task was assigned
  ///
  /// [List<dynamic>] comments - list of comments for this task
  ///
  /// [Timestamp] dueTime - date this task is flagged as due
  ///

  // fromFirestore<SwimlanesTask>(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  factory SwimlanesTask.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? snapshotOptions,
  ) {
    Map<String, dynamic> json = snapshot.data()!;
    String iconName =
        json['icon'] == null ? 'trip_origin_outlined' : json['icon'] as String;
    String hexColor = json['color'] == null ? '' : json['color'] as String;

    SwimlanesTask swimlaneTask = SwimlanesTask(
      id: snapshot.id,
      name: json['name'],
      priority: json['priority'] ?? 5,
      active: json['active'] ?? true,
      icon: getSwimLaneTaskIcon(iconName: iconName),
      color: getSwimLaneTaskColor(hexColor: hexColor),
      status: json['status'] ?? "new",
      description: json['description'] ?? '<no description>',
      creationDate: json['creationDate'],
      createdBy: json['createdBy'] != null ? json['createdBy'] as String : null,
      linkedPath: json['linkedPath'],
      linkedDocumentId: json['linkedDocumentId'],
      assignedTo: json['assignedTo'],
      assignmentTime: json['assignmentTime'],
      comments: json['zzComments'] ?? {},
      followers: json['zzFollowers'] ?? [],
      dueTime: json['dueTime'] != null ? json['dueTime'] as Timestamp : null,
      saveCount: json['saveCount'] != null ? json['saveCount'] as double : 0,
      // changeHistory: json['changeHistory'] != null
      //     ? json['changeHistory'] as Map<String, Timestamp>
      //     : {},
    );

    return swimlaneTask;
  }

  String? id;
  QueryDocumentSnapshot? snapshot;
  String? name;
  int priority;
  bool? active;
  IconData? icon;
  Color? color;
  String status;
  String? description;
  Timestamp? creationDate;
  String? createdBy;
  String? linkedPath;
  String? linkedDocumentId;
  String? assignedTo;
  Timestamp? assignmentTime;
  Timestamp? dueTime;
  Map<String, dynamic> comments;
  List followers;

  int get commentCount {
    return comments.length;
  }

  double saveCount;
  // Map<String, Timestamp>? changeHistory;

  Map<String, Object?> toFirestore() {
    String updatedBy =
        FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous";

    final Map<String, Timestamp> changeHistory = {updatedBy: Timestamp.now()};

    return {
      "active": active,
      "name": name,
      "priority": priority,
      "status": status,
      "description": description,
      "creationDate": creationDate ?? Timestamp.now(),
      "createdBy": createdBy ??
          FirebaseAuth.instance.currentUser?.displayName ??
          "Anonymous",
      "assignedTo": assignedTo,
      "assignmentTime": assignmentTime,
      "dueTime": creationDate ?? Timestamp.now(),
      "saveCount": saveCount,
      "changeHistory": FieldValue.arrayUnion([changeHistory]),
    };
  }
}

IconData getSwimLaneTaskIcon({required String iconName}) {
  if (iconMap.containsKey(iconName)) {
    IconData iconData = iconMap[iconName] as IconData;
    return iconData;
  } else {
    return iconMap["assignment"] as IconData;
  }
}

Color getSwimLaneTaskColor({required String hexColor}) {
  hexColor = hexColor.replaceAll("#", "");

  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  } else {
    return const Color.fromARGB(255, 125, 125, 125);
  }
}
