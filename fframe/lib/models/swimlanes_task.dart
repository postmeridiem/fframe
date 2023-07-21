part of fframe;

class SwimlanesTask extends ChangeNotifier {
  SwimlanesTask({
    this.id,
    this.name,
    this.priority = 5,
    this.active,
    this.icon,
    this.color,
    this.status = "new",
    this.description,
    this.creationDate,
    this.createdBy,
    this.assignedTo,
    this.assignmentTime,
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
      name: json['name']! as String,
      priority: json['priority'] == null ? 5 : json['priority'] as int,
      active: json['active'] == null ? true : json['active'] as bool,
      icon: getSwimLaneTaskIcon(iconName: iconName),
      color: getSwimLaneTaskColor(hexColor: hexColor),
      status: json['status'] == null ? "new" : json['status'] as String,
      description: json['description'] == null
          ? '<no description>'
          : json['description'] as String,
      creationDate: json['creationDate'] != null
          ? json['creationDate'] as Timestamp
          : null,
      createdBy: json['createdBy'] != null ? json['createdBy'] as String : null,
      assignedTo:
          json['assignedTo'] != null ? json['assignedTo'] as String : null,
      assignmentTime: json['assignmentTime'] != null
          ? json['assignmentTime'] as Timestamp
          : null,
      dueTime: json['dueTime'] != null ? json['dueTime'] as Timestamp : null,
      saveCount: json['saveCount'] != null ? json['saveCount'] as double : 0,
      // changeHistory: json['changeHistory'] != null
      //     ? json['changeHistory'] as Map<String, Timestamp>
      //     : {},
    );

    return swimlaneTask;
  }

  String? id;
  String? name;
  int priority;
  bool? active;
  IconData? icon;
  Color? color;
  String status;
  String? description;
  Timestamp? creationDate;
  String? createdBy;
  String? assignedTo;
  Timestamp? assignmentTime;
  Timestamp? dueTime;
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
      // "changeHistory": FieldValue.arrayUnion([changeHistory]),
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
