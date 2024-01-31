part of '../../fframe.dart';

class SwimlanesConfig<T> {
  SwimlanesConfig({
    required this.swimlaneSettings,
    required this.trackerId,
    required this.getStatus,
    required this.getName,
    // required this.getId,
    // required this.getLinkedId,
    // required this.getLinkedPath,
    // required this.getAssignee,
    // required this.getFollowers,
    required this.getPriority,
    required this.getDescription,
    required this.taskWidget,
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
  final String Function(T) getStatus;
  final String Function(T) getName;
  // final String Function(T) getId;
  // final String? Function(T) getLinkedId;
  // final String Function(T) getLinkedPath;
  // final String Function(T) getAssignee;
  final String Function(T) getDescription;
  // final List<String> Function(T) getFollowers;
  final double Function(T) getPriority;
  final Widget Function(SelectedDocument<T>, SwimlanesConfig<T>, FFrameUser) taskWidget;
  // final String Function(T)? getStatus;
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
    required this.id,
    required this.header,
    required this.onLaneDrop,
    required this.onPriorityChange,
    required this.canChangePriority,
    required this.canChangeSwimLane,
    this.query,
    this.roles,
    this.swimlaneWidth = 200,
    this.cardControlsBuilder,
  });
  final String id;
  final String header;
  final List<String>? roles;
  final double swimlaneWidth;
  final SwimlanesCardControlsBuilderFunction<T>? cardControlsBuilder;
  final Query<T>? Function(Query<T> query)? query;
  final bool Function(SelectedDocument<T> selectedDocument, List<String> userRoles, String sourceLaneId, int sourcePriority, int targetPriority) canChangePriority;
  final bool Function(SelectedDocument<T> selectedDocument, List<String> userRoles, String sourceLaneId, int sourcePriority, int targetPriority) canChangeSwimLane;
  final T Function(T data, double? priority) onLaneDrop;
  final T Function(T data, double? priority) onPriorityChange;
  late int? swimlaneIndex;
  late bool hasAccess = false;
}

class DragContext<T> {
  final SwimlaneSetting<T> sourceColumn;
  final SelectedDocument<T> selectedDocument;
  final GlobalKey dragKey;
  final BuildContext buildContext;

  DragContext({
    required this.dragKey,
    required this.sourceColumn,
    required this.selectedDocument,
    required this.buildContext,
  });
}

// class SwimlanesDataModeConfig {
//   const SwimlanesDataModeConfig({
//     this.mode = SwimlanesDataMode.limit,
//     this.limit = 100,
//     // this.autopagerRowHeight,
//   });
//   final SwimlanesDataMode mode;
//   final int limit;
//   // final double? autopagerRowHeight;
// }

// class SwimlanesSearchConfig {
//   const SwimlanesSearchConfig({
//     required this.mode,
//     this.field,
//     this.multiFields,
//   });
//   final SwimlanesSearchMode mode;
//   final String? field;
//   final List<String>? multiFields;
// }

// class SwimlanesSearchMask {
//   const SwimlanesSearchMask({
//     required this.from,
//     required this.to,
//     this.toLowerCase = false,
//   });
//   final String from;
//   final String to;
//   final bool toLowerCase;
// }

// class SwimlaneTaskDatabase<T> {
//   SwimlaneTaskDatabase({
//     required FFrameUser currentUser,
//     required this.swimlanesConfig,
//   }) : _currentUser = currentUser;
//   final SwimlanesConfig<T> swimlanesConfig;
//   final FFrameUser _currentUser;

//   late Map<int, String> statusList = {};

//   late Map<String, T> taskDb = {};
//   late Map<String, SwimlanesDbStatusSet> statusDb = {};
//   late Map<String, int> swimlaneCount = {};

//   void registerStatus({required int index, required String status}) {
//     // add the new status to the status list
//     statusList.addAll({index: status});
//   }

//   void registerTask(T task) {
//     String currentStatus = swimlanesConfig.getStatus(task);
//     int priority = swimlanesConfig.getPriority(task);
//     // add the task to the main task table
//     taskDb[swimlanesConfig.getId(task)] = task;

//     // add the data to the index tables
//     if (!statusDb.containsKey(currentStatus)) {
//       statusDb[currentStatus] = SwimlanesDbStatusSet(
//         status: currentStatus,
//         priority: priority,
//       );
//     }
//     SwimlanesDbStatusSet db = statusDb[currentStatus] as SwimlanesDbStatusSet;
//     db.registerTask(task);
//     int currentCount = swimlaneCount[currentStatus] ?? 0;
//     swimlaneCount[currentStatus] = currentCount;
//   }

//   int getSwimlaneCount({required String swimlaneStatus}) {
//     return swimlaneCount[swimlaneStatus] ?? 0;
//   }

//   List<T> getSwimlaneTasks({
//     required SwimlanesController swimlanesController,
//     required SwimlanesConfig<T> swimlanesConfig,
//     required SwimlaneSetting<T> swimlaneSetting,
//   }) {
//     List<T> output = [];

//     List<T> prio1Tasks = [];
//     List<T> prio2Tasks = [];
//     List<T> prio3Tasks = [];
//     List<T> prio4Tasks = [];
//     List<T> prio5Tasks = [];
//     List<T> prio6Tasks = [];
//     List<T> prio7Tasks = [];
//     List<T> prio8Tasks = [];
//     List<T> prio9Tasks = [];

//     for (MapEntry<String, T> currentRecord in taskDb.entries) {
//       T task = currentRecord.value;
//       if (swimlanesConfig.getStatus(task) == swimlaneSetting.status) {
//         bool filterPassed = false;
//         switch (swimlanesController.filter) {
//           case SwimlanesFilterType.unfiltered:
//             filterPassed = true;
//             break;
//           case SwimlanesFilterType.assignedToMe:
//             if (swimlanesController.database._currentUser.email == swimlanesConfig.getAssignee(task)) {
//               filterPassed = true;
//             }
//             break;
//           case SwimlanesFilterType.followedTasks:
//             if (swimlanesConfig.getFollowers(task).contains(swimlanesController.database._currentUser.email)) {
//               filterPassed = true;
//             }
//             break;
//           case SwimlanesFilterType.prioHigh:
//             if (swimlanesConfig.getPriority(task) == 1 || swimlanesConfig.getPriority(task) == 2 || swimlanesConfig.getPriority(task) == 3) {
//               filterPassed = true;
//             }
//             break;
//           case SwimlanesFilterType.prioNormal:
//             if (swimlanesConfig.getPriority(task) == 4 || swimlanesConfig.getPriority(task) == 5 || swimlanesConfig.getPriority(task) == 6) {
//               filterPassed = true;
//             }
//             break;
//           case SwimlanesFilterType.prioLow:
//             if (swimlanesConfig.getPriority(task) == 7 || swimlanesConfig.getPriority(task) == 8 || swimlanesConfig.getPriority(task) == 9) {
//               filterPassed = true;
//             }
//             break;
//           case SwimlanesFilterType.assignedTo:
//             // filterPassed = true;
//             break;
//           default:
//         }

//         if (filterPassed) {
//           switch (swimlanesConfig.getPriority(task)) {
//             case 1:
//               prio1Tasks.add(task);
//               break;
//             case 2:
//               prio2Tasks.add(task);
//               break;
//             case 3:
//               prio3Tasks.add(task);
//               break;
//             case 4:
//               prio4Tasks.add(task);
//               break;
//             case 5:
//               prio5Tasks.add(task);
//               break;
//             case 6:
//               prio6Tasks.add(task);
//               break;
//             case 7:
//               prio7Tasks.add(task);
//               break;
//             case 8:
//               prio8Tasks.add(task);
//               break;
//             case 9:
//               prio9Tasks.add(task);
//               break;
//             default:
//           }
//         }
//       }
//     }

//     output = [
//       ...prio1Tasks,
//       ...prio2Tasks,
//       ...prio3Tasks,
//       ...prio4Tasks,
//       ...prio5Tasks,
//       ...prio6Tasks,
//       ...prio7Tasks,
//       ...prio8Tasks,
//       ...prio9Tasks,
//     ];

//     // if (_statusDb.containsKey(currentStatus)) {
//     //   SwimlanesDbStatusSet db =
//     //       _statusDb[currentStatus] as SwimlanesDbStatusSet;
//     //   output = db.getSwimlaneTasks(swimlaneSetting: swimlaneSetting);
//     // }

//     return output;
//   }
// }

// class SwimlanesDbStatusSet<T> {
//   SwimlanesDbStatusSet({
//     required this.status,
//     required this.priority,
//   });
//   final String status;
//   final int priority;
//   late List<T> prio1Tasks = [];
//   late List<T> prio2Tasks = [];
//   late List<T> prio3Tasks = [];
//   late List<T> prio4Tasks = [];
//   late List<T> prio5Tasks = [];
//   late List<T> prio6Tasks = [];
//   late List<T> prio7Tasks = [];
//   late List<T> prio8Tasks = [];
//   late List<T> prio9Tasks = [];
//   //Map<int, List<T>>

//   void registerTask(T task) {
//     switch (priority) {
//       case 1:
//         prio1Tasks.add(task);
//         break;
//       case 2:
//         prio2Tasks.add(task);
//         break;
//       case 3:
//         prio3Tasks.add(task);
//         break;
//       case 4:
//         prio4Tasks.add(task);
//         break;
//       case 5:
//         prio5Tasks.add(task);
//         break;
//       case 6:
//         prio6Tasks.add(task);
//         break;
//       case 7:
//         prio7Tasks.add(task);
//         break;
//       case 8:
//         prio8Tasks.add(task);
//         break;
//       case 9:
//         prio9Tasks.add(task);
//         break;
//       default:
//     }
//   }

//   List<T> getSwimlaneTasks({
//     required SwimlaneSetting swimlaneSetting,
//     String? assignedTo,
//     int? priorityFilter,
//   }) {
//     return [
//       ...prio1Tasks,
//       ...prio2Tasks,
//       ...prio3Tasks,
//       ...prio4Tasks,
//       ...prio5Tasks,
//       ...prio6Tasks,
//       ...prio7Tasks,
//       ...prio8Tasks,
//       ...prio9Tasks,
//     ];
//   }
// }

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
  T data,
  String stringValue,
);
