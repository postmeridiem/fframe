part of fframe;

class SwimlanesConfig<T> {
  SwimlanesConfig({
    required this.swimlaneSettings,
    required this.trackerId,
    this.swimlaneBackgroundColor,
    this.swimlaneHeaderColor,
    this.swimlaneHeaderTextColor,
    this.swimlaneHeaderSeparatorColor,
    this.taskCardColor,
    this.taskCardTextColor,
    this.taskCardHeaderColor,
    this.taskCardHeaderTextColor,
    this.swimlaneWidth = 400,
  });

  final List<SwimlaneSetting<T>> swimlaneSettings;
  final String trackerId;
  final Color? swimlaneBackgroundColor;
  final Color? swimlaneHeaderColor;
  final Color? swimlaneHeaderTextColor;
  final Color? swimlaneHeaderSeparatorColor;
  final Color? taskCardColor;
  final Color? taskCardTextColor;
  final Color? taskCardHeaderColor;
  final Color? taskCardHeaderTextColor;
  final double swimlaneWidth;

  late T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
      fromFirestore;
  late Map<String, Object?> Function(T, SetOptions?) toFirestore;
}

class SwimlanesActionMenu<T> {
  const SwimlanesActionMenu({
    required this.menuItems,
    this.label,
    this.icon,
  });
  final List<SwimlanesActionMenuItem> menuItems;
  final String? label;
  final IconData? icon;
}

class SwimlanesActionMenuItem<T> {
  const SwimlanesActionMenuItem({
    required this.label,
    required this.icon,
    this.requireSelection = true,
    required this.clickHandler,
  });
  final String label;
  final IconData icon;
  final bool requireSelection;
  final SwimlanesActionHandler<T> clickHandler;
}

class SwimlaneSetting<T> {
  SwimlaneSetting({
    required this.header,
    required this.status,
    this.roles,
    this.swimlaneWidth = 200,
    this.cardControlsBuilder,

    // this.dynamicTextStyle,
    // this.dynamicBackgroundColor,
  });
  String header;
  String status;
  List<String>? roles;
  double swimlaneWidth;
  SwimlanesCardControlsBuilderFunction<T>? cardControlsBuilder;

  late int? swimlaneIndex;
  late bool hasAccess = false;
}

class SwimlanesDataModeConfig {
  const SwimlanesDataModeConfig({
    this.mode = SwimlanesDataMode.limit,
    this.limit = 100,
    // this.autopagerRowHeight,
  });
  final SwimlanesDataMode mode;
  final int limit;
  // final double? autopagerRowHeight;
}

class SwimlanesSearchConfig {
  const SwimlanesSearchConfig({
    required this.mode,
    this.field,
    this.multiFields,
  });
  final SwimlanesSearchMode mode;
  final String? field;
  final List<String>? multiFields;
}

class SwimlanesSearchMask {
  const SwimlanesSearchMask({
    required this.from,
    required this.to,
    this.toLowerCase = false,
  });
  final String from;
  final String to;
  final bool toLowerCase;
}

class SwimlaneTaskDatabase {
  SwimlaneTaskDatabase({
    required this.currentUser,
  });
  final FFrameUser currentUser;

  late Map<int, String> statusList = {};

  late Map<String, SwimlanesTask> taskDb = {};
  late Map<String, SwimlanesDbStatusSet> statusDb = {};
  late Map<String, int> swimlaneCount = {};

  void registerStatus({required int index, required String status}) {
    // add the new status to the status list
    statusList.addAll({index: status});
  }

  void registerTask(SwimlanesTask task) {
    String currentStatus = task.status;
    // add the task to the main task table
    taskDb[task.id ?? "error"] = task;

    // add the data to the index tables
    if (!statusDb.containsKey(currentStatus)) {
      statusDb[currentStatus] = SwimlanesDbStatusSet(status: currentStatus);
    }
    SwimlanesDbStatusSet db = statusDb[currentStatus] as SwimlanesDbStatusSet;
    db.registerTask(task);
    int currentCount = swimlaneCount[currentStatus] ?? 0;
    swimlaneCount[currentStatus] = currentCount;
  }

  int getSwimlaneCount({required String swimlaneStatus}) {
    return swimlaneCount[swimlaneStatus] ?? 0;
  }

  List<SwimlanesTask> getSwimlaneTasks({
    required SwimlanesController swimlanes,
    required SwimlaneSetting swimlane,
  }) {
    List<SwimlanesTask> output = [];

    List<SwimlanesTask> prio1Tasks = [];
    List<SwimlanesTask> prio2Tasks = [];
    List<SwimlanesTask> prio3Tasks = [];
    List<SwimlanesTask> prio4Tasks = [];
    List<SwimlanesTask> prio5Tasks = [];
    List<SwimlanesTask> prio6Tasks = [];
    List<SwimlanesTask> prio7Tasks = [];
    List<SwimlanesTask> prio8Tasks = [];
    List<SwimlanesTask> prio9Tasks = [];

    for (MapEntry<String, SwimlanesTask> curRecord in taskDb.entries) {
      SwimlanesTask task = curRecord.value;
      if (task.status == swimlane.status) {
        bool filterPassed = false;
        switch (swimlanes.filter) {
          case SwimlanesFilterType.unfiltered:
            filterPassed = true;
            break;
          case SwimlanesFilterType.assignedToMe:
            if (swimlanes.database.currentUser.email == task.assignedTo) {
              filterPassed = true;
            }
            break;
          case SwimlanesFilterType.followedTasks:
            // filterPassed = true;
            break;
          case SwimlanesFilterType.prioHigh:
            if (task.priority == 1 ||
                task.priority == 2 ||
                task.priority == 3) {
              filterPassed = true;
            }
            break;
          case SwimlanesFilterType.prioNormal:
            if (task.priority == 4 ||
                task.priority == 5 ||
                task.priority == 6) {
              filterPassed = true;
            }
            break;
          case SwimlanesFilterType.prioLow:
            if (task.priority == 7 ||
                task.priority == 8 ||
                task.priority == 9) {
              filterPassed = true;
            }
            break;
          case SwimlanesFilterType.assignedTo:
            // filterPassed = true;
            break;
          default:
        }

        if (filterPassed) {
          switch (task.priority) {
            case 1:
              prio1Tasks.add(task);
              break;
            case 2:
              prio2Tasks.add(task);
              break;
            case 3:
              prio3Tasks.add(task);
              break;
            case 4:
              prio4Tasks.add(task);
              break;
            case 5:
              prio5Tasks.add(task);
              break;
            case 6:
              prio6Tasks.add(task);
              break;
            case 7:
              prio7Tasks.add(task);
              break;
            case 8:
              prio8Tasks.add(task);
              break;
            case 9:
              prio9Tasks.add(task);
              break;
            default:
          }
        }
      }
    }

    output = [
      ...prio1Tasks,
      ...prio2Tasks,
      ...prio3Tasks,
      ...prio4Tasks,
      ...prio5Tasks,
      ...prio6Tasks,
      ...prio7Tasks,
      ...prio8Tasks,
      ...prio9Tasks,
    ];

    // if (_statusDb.containsKey(currentStatus)) {
    //   SwimlanesDbStatusSet db =
    //       _statusDb[currentStatus] as SwimlanesDbStatusSet;
    //   output = db.getSwimlaneTasks(swimlane: swimlane);
    // }

    return output;
  }
}

class SwimlanesDbStatusSet {
  SwimlanesDbStatusSet({
    required this.status,
  });
  final String status;
  late List<SwimlanesTask> prio1Tasks = [];
  late List<SwimlanesTask> prio2Tasks = [];
  late List<SwimlanesTask> prio3Tasks = [];
  late List<SwimlanesTask> prio4Tasks = [];
  late List<SwimlanesTask> prio5Tasks = [];
  late List<SwimlanesTask> prio6Tasks = [];
  late List<SwimlanesTask> prio7Tasks = [];
  late List<SwimlanesTask> prio8Tasks = [];
  late List<SwimlanesTask> prio9Tasks = [];
  //Map<int, List<SwimlanesTask>>

  void registerTask(SwimlanesTask task) {
    switch (task.priority) {
      case 1:
        prio1Tasks.add(task);
        break;
      case 2:
        prio2Tasks.add(task);
        break;
      case 3:
        prio3Tasks.add(task);
        break;
      case 4:
        prio4Tasks.add(task);
        break;
      case 5:
        prio5Tasks.add(task);
        break;
      case 6:
        prio6Tasks.add(task);
        break;
      case 7:
        prio7Tasks.add(task);
        break;
      case 8:
        prio8Tasks.add(task);
        break;
      case 9:
        prio9Tasks.add(task);
        break;
      default:
    }
  }

  List<SwimlanesTask> getSwimlaneTasks({
    required SwimlaneSetting swimlane,
    String? assignedTo,
    int? priorityFilter,
  }) {
    return [
      ...prio1Tasks,
      ...prio2Tasks,
      ...prio3Tasks,
      ...prio4Tasks,
      ...prio5Tasks,
      ...prio6Tasks,
      ...prio7Tasks,
      ...prio8Tasks,
      ...prio9Tasks,
    ];
  }
}

class SwimlanesDbStatusSetByUser {
  const SwimlanesDbStatusSetByUser({
    required this.status,
  });
  final String status;
  void registerTask(SwimlanesTask task) {}
}

enum SwimlanesDataMode {
  all,
  autopager,
  lazy,
  limit,
  pager,
}

enum SwimlanesSearchMode {
  singleFieldString,
  multiFieldString,
  underscoreTypeAhead,
}

enum SwimlanesFilterType {
  unfiltered,
  assignedToMe,
  followedTasks,
  assignedTo,
  prioHigh,
  prioNormal,
  prioLow,
  prio1,
  prio2,
  prio3,
  prio4,
  prio5,
  prio6,
  prio7,
  prio8,
  prio9,
}

typedef SwimlanesActionHandler<T> = void Function(
  BuildContext context,
  FFrameUser? user,
  Map<String, T> selectedDocumentsById,
);

typedef SwimlanesValueBuilderFunction<T> = dynamic Function(
  BuildContext context,
  T data,
);

typedef SwimlanesCellBuilderFunction<T> = Widget Function(
  BuildContext context,
  T data,
  Function save,
);

typedef SwimlanesCardControlsBuilderFunction<T> = List<IconButton> Function(
  BuildContext context,
  FFrameUser? user,
  dynamic data,
  String stringValue,
);
