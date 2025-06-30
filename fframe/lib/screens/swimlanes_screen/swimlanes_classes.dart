part of 'package:fframe/fframe.dart';

class SwimlanesConfig<T> extends ListConfig {
  SwimlanesConfig({
    required this.swimlaneSettings,
    required this.trackerId,
    required this.getStatus,
    required this.getTitle,
    required this.getDescription,
    required this.taskWidgetHeader,
    required this.taskWidgetBody,
    this.getPriority,
    this.getLanePosition,
    this.assignee,
    this.myId,
    this.following,
    this.customFilter,
    this.swimlaneBackgroundColor,
    this.swimlaneHeaderColor,
    this.swimlaneHeaderTextColor,
    this.swimlaneHeaderSeparatorColor,
    this.taskCardColor,
    this.taskCardTextColor,
    this.taskCardHeaderColor,
    this.taskCardHeaderTextColor,
    this.swimlaneWidth = 400,
    this.openDocumentOnClick = true,
    this.isReadOnly = false,
  }) : assert(
            // Ensure myId is not null when any of the methods is set
            myId != null || assignee == null && assignee == null && following == null,
            'If any of the methods (getAssignee, setAssignee, isFollowing, startFollowing, unstartFollowing) is set, myId must not be null.');

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
  final SwimlanesFollowing<T>? following;
  final SwimlanesCustomFilter<T>? customFilter;
  final SwimlanesAssignee<T>? assignee;
  final String Function(T) getDescription;
  final double Function(T)? getPriority;
  final double Function(T)? getLanePosition;
  final Widget Function(SelectedDocument<T>, SwimlanesConfig<T>, FFrameUser) taskWidgetHeader;
  final Widget Function(SelectedDocument<T>, SwimlanesConfig<T>, FFrameUser) taskWidgetBody;
  final bool openDocumentOnClick;
  final bool isReadOnly;
}

class SwimlanesFollowing<T> {
  SwimlanesFollowing({
    required this.isFollowing,
    required this.startFollowing,
    required this.stopFollowing,
  });
  final bool Function(T, FFrameUser) isFollowing;
  final T Function(T, FFrameUser) startFollowing;
  final T Function(T, FFrameUser) stopFollowing;
}

class SwimlanesAssignee<T> {
  SwimlanesAssignee({
    required this.isAssignee,
    required this.setAssignee,
    required this.unsetAssignee,
  });
  final bool Function(T, FFrameUser) isAssignee;
  final T Function(T, FFrameUser) setAssignee;
  final T Function(T) unsetAssignee;
}

class SwimlanesCustomFilter<T> {
  SwimlanesCustomFilter({
    required this.filterName,
    required this.matchesCustomFilter,
    this.customFilterWidget,
  });
  // Custom filter name shown amongst the client-side filters (only if there's no customFilterWidget defined)
  final String filterName;

  // Tells if the document (T) is matching with a custom filter
  // e.g. use case for selected label matching
  // matchesCustomFilter: (cardDoc) {
  //   bool? hasLabel = cardDoc.labels?.include(selectedLabelId);
  //   return hasLabel == true ? hasLabel : false;
  // }
  final bool Function(T) matchesCustomFilter;

  // How the filter option should be shown amongst the other client-side filters.
  // If not defined, it'll be shown as the others.
  final Widget Function(SwimlanesController)? customFilterWidget;
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
    this.onLaneDrop,
    this.onPriorityChange,
    this.onLanePositionChange,
    this.canChangePriority,
    this.canChangeSwimLane,
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
  final bool Function(SelectedDocument<T> selectedDocument, List<String> userRoles, String sourceLaneId, int sourcePriority, int targetPriority)? canChangePriority;
  final bool Function(SelectedDocument<T> selectedDocument, List<String> userRoles, String sourceLaneId, int? sourcePriority, int? targetPriority)? canChangeSwimLane;
  final T Function(
    T data,
    double? priority,
    SelectedDocument<T> selectedDocument,
  )? onLaneDrop;
  final T Function(T data, double? priority)? onPriorityChange;
  final T Function(T data, double? lanePosition)? onLanePositionChange; // If defined, it is prioritised over onPriorityChange as the primary ordering method within lanes
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
  customFilter,
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
