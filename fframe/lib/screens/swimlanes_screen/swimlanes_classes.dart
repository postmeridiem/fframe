part of '../../fframe.dart';

class SwimlanesConfig<T> {
  SwimlanesConfig({
    required this.swimlaneSettings,
    required this.trackerId,
    required this.getStatus,
    required this.getTitle,
    required this.getDescription,
    required this.taskWidget,
    this.getPriority,
    this.getAssignee,
    this.setAssignee,
    this.myId,
    this.watching,
    this.watch,
    this.unWatch,
    this.swimlaneBackgroundColor,
    this.swimlaneHeaderColor,
    this.swimlaneHeaderTextColor,
    this.swimlaneHeaderSeparatorColor,
    this.taskCardColor,
    this.taskCardTextColor,
    this.taskCardHeaderColor,
    this.taskCardHeaderTextColor,
    this.swimlaneWidth = 400,
  })  : assert(
            // Ensure myId is not null when any of the methods is set
            myId != null || getAssignee == null && setAssignee == null && watching == null && watch == null && unWatch == null,
            'If any of the methods (getAssignee, setAssignee, watching, watch, unWatch) is set, myId must not be null.'),
        assert(
          // Ensure if getAssignee is set, setAssignee must also be set
          (getAssignee == null && setAssignee == null) || (getAssignee != null && setAssignee != null),
          'If getAssignee is set, setAssignee must also be set.',
        ),
        assert(
          // Ensure if watching is set, both watch and unWatch must also be set
          (watching == null && watch == null && unWatch == null) || (watching != null && watch != null && unWatch != null),
          'If watching is set, both watch and unWatch must also be set.',
        );

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
  final String Function(T) getTitle;
  final String Function(FFrameUser)? myId;
  final String Function(T)? getAssignee;
  final T Function(T, String)? setAssignee;
  final bool Function(T)? watching;
  final T Function(T)? watch;
  final T Function(T)? unWatch;
  final String Function(T) getDescription;
  final double Function(T)? getPriority;
  final Widget Function(SelectedDocument<T>, SwimlanesConfig<T>, FFrameUser) taskWidget;
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
  final bool Function(SelectedDocument<T> selectedDocument, List<String> userRoles, String sourceLaneId, int? sourcePriority, int? targetPriority) canChangeSwimLane;
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

// typedef SwimlanesValueBuilderFunction<T> = dynamic Function(
//   BuildContext context,
//   T data,
// );

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
