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

class SwimlanesMovementLock {
  const SwimlanesMovementLock({
    this.incoming = false,
    this.outgoing = false,
  });

  /// Whether cards can be dropped into this lane from other lanes.
  /// If `true`, cards cannot be dropped into this lane.
  final bool incoming;

  /// Whether cards can be dragged out of this lane to other lanes.
  /// If `true`, cards cannot be dragged out of this lane.
  final bool outgoing;

  /// Returns true if both incoming and outgoing are locked.
  bool get isFullyLocked => incoming && outgoing;

  /// Returns true if either incoming or outgoing is locked.
  bool get isPartiallyLocked => incoming || outgoing;

  /// Returns true if no locks are applied.
  bool get isUnlocked => !incoming && !outgoing;
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
    this.allowCardCreation = false,
    this.onNewCard,
    this.onCardCreated,
    this.addCardButtonStyle,
    this.openNewCard = false,
    this.movementLock = const SwimlanesMovementLock(),
    this.movementLockTooltip,
  }) : assert(
          allowCardCreation == false || onNewCard != null,
          "Configuration error in SwimlaneSetting: 'onNewCard' must be provided when 'allowCardCreation' is true.",
        );
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

  /// Whether to show a button to create a new card at the bottom of the swimlane.
  ///
  /// Defaults to `false`.
  /// If `true`, [onNewCard] must be provided.
  /// The developer is responsible for implementing any role-based security
  /// by conditionally setting this property based on user roles.
  final bool allowCardCreation;

  /// A callback that returns a new instance of the data model `T` when the
  /// "add card" button is pressed.
  ///
  /// The callback receives the `laneId`, the calculated `lanePosition`, and the
  /// `priority` for the new card. This data should be used to initialize the new object.
  /// The returned object will be saved as a new document in Firestore.
  ///
  /// This is required if [allowCardCreation] is `true`.
  final T Function(String laneId, double? lanePosition, double? priority)? onNewCard;

  /// Callback executed after a new card is successfully created.
  ///
  /// It receives the `documentId` and the `data` of the new card.
  /// This can be used for custom logic, like opening a new URL that
  /// directly navigates to the newly created card.
  ///
  /// Example:
  /// ```dart
  /// onCardCreated: (documentId, data) {
  ///   Fframe.of(context).navigateTo('/suggestions/$documentId');
  /// }
  /// ```
  final void Function(String documentId, T data)? onCardCreated;

  /// Custom [ButtonStyle] for the "Add a card" button.
  ///
  /// If not provided, a default style will be used.
  final ButtonStyle? addCardButtonStyle;

  /// Whether to automatically open the newly created card within the app.
  ///
  /// When set to `true`, after a new card is created, it will be
  /// automatically opened in the document view. This provides a quick way for
  /// users to start editing the new card right away.
  ///
  /// Defaults to `false`.
  final bool openNewCard;

  /// Configures movement restrictions for cards in this swimlane.
  ///
  /// Allows granular control over card movement:
  /// - `incoming`: If `true`, prevents cards from being dropped into this lane from other lanes
  /// - `outgoing`: If `true`, prevents cards from being dragged out of this lane to other lanes
  ///
  /// Example:
  /// ```dart
  /// movementLock: SwimlanesMovementLock(incoming: true, outgoing: false)
  /// ```
  /// This allows cards to move out but not into the lane.
  final SwimlanesMovementLock movementLock;

  /// Custom tooltip message to display when hovering over the movement lock icon.
  ///
  /// If provided, this will override the default tooltip messages.
  /// Use this to provide specific information about which lanes cards can be moved to/from.
  ///
  /// Example:
  /// ```dart
  /// movementLockTooltip: 'Can only move to "Completed Card" lane'
  /// ```
  final String? movementLockTooltip;

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
