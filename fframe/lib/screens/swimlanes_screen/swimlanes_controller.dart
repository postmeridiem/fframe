part of fframe;

// ignore: must_be_immutable
class SwimlanesController extends InheritedModel {
  SwimlanesController({
    super.key,
    required child,
    required this.context,
    required this.sourceQuery,
    required this.theme,
    required this.config,
    required this.viewportSize,
    required this.documentOpen,
  }) : super(child: child) {
    // get a handle to the current user
    FFrameUser currentUser = Fframe.of(context)!.user as FFrameUser;
    List<String> currentRoles = [];
    // get the user's roles
    if (currentUser.roles != null) {
      currentRoles = currentUser.roles as List<String>;
    }

    // initialize the tasks database
    database = SwimlaneTaskDatabase(currentUser: currentUser);
    double calculatedMinWidth = 0;

    for (var i = 0; i < (config.swimlaneSettings.length); i++) {
      // get the settings for the current swimlane
      SwimlaneSetting swimlaneSetting = swimlaneSettings[i];
      database.registerStatus(index: i, status: swimlaneSetting.status);

      if (swimlaneSetting.roles == null) {
        // there is no role configuration, defaulting to hasAccess
        swimlaneSetting.hasAccess = true;

        // calculate the grid width based on visibility
        swimlaneSetting.swimlaneIndex = i;
      } else {
        List<String> swimlaneRoles = swimlaneSetting.roles as List<String>;
        // check user roles for access to this swimlane
        for (String swimlaneRole in swimlaneRoles) {
          if (currentRoles.contains(swimlaneRole)) {
            swimlaneSetting.hasAccess = true;
          } else {
            swimlaneSetting.hasAccess = false;
          }
        }
      }

      // add this swimlane's width to the min width.
      // each flex swimlane will add the default swimlane width
      // unless specified otherwise
      calculatedMinWidth += swimlaneSetting.swimlaneWidth;
    }
    _viewportWidth = _getViewportWidth(viewportSize: viewportSize);
    _calculatedWidth = _calculateWidth(calculatedMinWidth, viewportWidth);

    // register the grid controller update notifier
    notifier = SwimlanesNotifier(
      sourceQuery: sourceQuery,
      swimlaneSettings: swimlaneSettings,
    );
  }
  late SwimlanesNotifier notifier;

  final BuildContext context;
  final SwimlanesConfig config;
  final ThemeData theme;
  final Size viewportSize;
  final bool documentOpen;

  late Query sourceQuery;
  late SwimlaneTaskDatabase database;
  late double _calculatedWidth;
  late double _viewportWidth;

  // late Map<String, bool> listGridSelection = {};

  Color get swimlaneBackgroundColor {
    return config.swimlaneBackgroundColor ??
        theme.colorScheme.secondaryContainer;
  }

  Color get swimlaneHeaderColor {
    return config.swimlaneHeaderColor ?? theme.colorScheme.primaryContainer;
  }

  Color get swimlaneHeaderTextColor {
    return config.swimlaneHeaderTextColor ??
        theme.colorScheme.onPrimaryContainer;
  }

  Color get swimlaneHeaderSeparatorColor {
    return config.swimlaneHeaderSeparatorColor ??
        theme.colorScheme.primaryContainer;
  }

  Color get swimlaneSeparatorColor {
    return config.swimlaneHeaderSeparatorColor ??
        theme.colorScheme.onBackground;
  }

  Color get taskCardColor {
    return config.taskCardColor ?? theme.colorScheme.surfaceVariant;
  }

  Color get taskCardTextColor {
    return config.taskCardTextColor ?? theme.colorScheme.onSurfaceVariant;
  }

  Color get taskCardHeaderColor {
    return config.taskCardHeaderColor ?? theme.colorScheme.surface;
  }

  Color get taskCardHeaderTextColor {
    return config.taskCardHeaderTextColor ?? theme.colorScheme.onSurface;
  }

  double get calculatedWidth {
    return _calculatedWidth;
  }

  double get viewportWidth {
    return _viewportWidth;
  }

  double get headerHeight {
    return 70;
  }

  List<SwimlaneSetting> get swimlaneSettings {
    return config.swimlaneSettings;
  }

  Query get currentQuery {
    return notifier._currentQuery;
  }

  SwimlanesFilterType get filter {
    return notifier.filter;
  }

  bool get isDragging {
    return notifier.isDragging;
  }

  set taskDragging(bool isDragging) {
    notifier.setDraggingMode(isDragging);
  }

  double _calculateWidth(double calculatedMinWidth, double viewportWidth) {
    double calculatedWidth =
        calculatedMinWidth > viewportWidth ? calculatedMinWidth : viewportWidth;
    return calculatedWidth;
  }

  double _getViewportWidth({required Size viewportSize}) {
    double viewportWidth = ((viewportSize.width > 1000)
        ? (viewportSize).width - 100
        : (viewportSize.width + 0));
    return viewportWidth;
  }

  double _getViewportHeight({required Size viewportSize}) {
    double viewportWidth = ((viewportSize.width > 1000)
        ? (viewportSize).width - 100
        : (viewportSize.width + 0));
    return viewportWidth;
  }

  @override
  bool updateShouldNotify(covariant SwimlanesController oldWidget) {
    bool updated = false;

    // test if any fields are changed that should trigger an update
    updated = (config != oldWidget.config) ? true : updated;
    updated = (swimlaneSettings != oldWidget.swimlaneSettings) ? true : updated;
    updated = (theme != oldWidget.theme) ? true : updated;
    // updated = (theme != oldWidget.task) ? true : updated;

    notifier.update();
    return updated;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant InheritedModel oldWidget,
    Set dependencies,
  ) {
    // TODO: implement updateShouldNotifyDependent
    return true;
  }

  static SwimlanesController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SwimlanesController>();
  }

  static SwimlanesController of(BuildContext context) {
    final SwimlanesController? result = maybeOf(context);

    assert(result != null, 'No SwimlanesController found in context');
    return result!;
  }
}

class SwimlanesNotifier<T> extends ChangeNotifier {
  SwimlanesNotifier({
    required this.sourceQuery,
    // required this.searchConfig,
    required this.swimlaneSettings,
  }) : super() {
    // not empyy
    _searchString = '';
    _collectionCount = 0;

    // initialize the row selections
    // _selectedDocuments = {};

    // initialize the current query, based on sorting and settings
    _currentQuery = sourceQuery;
    _queryBuilder();

    // initial filter: unfiltered
    _filter = SwimlanesFilterType.unfiltered;

    // initial load: no task is dragging
    _taskDragging = false;

    //update the collection count
    _updateCollectionCount(query: _currentQuery);
  }
  final Query sourceQuery;
  final List<SwimlaneSetting> swimlaneSettings;

  late String? _searchString;
  late int _collectionCount;
  late Query _currentQuery;
  late bool _taskDragging;
  late SwimlanesFilterType _filter;

  String? get searchString {
    return _searchString;
  }

  set searchString(String? searchString) {
    //TODO: add some kind of rate limiting
    if (searchString != null && searchString.isNotEmpty) {
      _searchString = searchString;
    } else {
      _searchString = null;
    }
    _queryBuilder();
  }

  void _queryBuilder() {
    Query outputQuery = sourceQuery;

    // apply the newly computedQuery as the current query
    _currentQuery = outputQuery;

    // the query has changed; recalculate the result collection count
    _updateCollectionCount(query: _currentQuery);

    // notify the listeners that a redraw is needed
    notifyListeners();
  }

  int get collectionCount {
    return _collectionCount;
  }

  set collectionCount(int collectionCount) {
    _collectionCount = collectionCount;
    notifyListeners();
  }

  bool get isDragging {
    return _taskDragging;
  }

  SwimlanesFilterType get filter {
    return _filter;
  }

  void setFilter(SwimlanesFilterType filter) {
    _filter = filter;
    notifyListeners();
  }

  void setDraggingMode(bool isDragging) {
    _taskDragging = isDragging;
    notifyListeners();
  }

  void _updateCollectionCount({required Query query}) async {
    // AggregateQuerySnapshot snapshot = await query.count().get();
    // int collectionCount = snapshot.count;
    // _collectionCount = collectionCount;
  }

  void update() {
    notifyListeners();
  }
}
