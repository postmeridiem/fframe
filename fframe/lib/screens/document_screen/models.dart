part of '../../fframe.dart';

class DocumentConfig<T> extends ChangeNotifier {
  DocumentConfig({
    required this.formKey,
    required this.collection,
    required this.createNew,
    required this.initialViewType,
    this.preSave,
    this.preOpen,
    this.createDocumentId,
    required this.fromFirestore,
    required this.toFirestore,
    this.query,
    this.searchConfig,
    this.documentList,
    this.dataGridConfig,
    this.listGridConfig,
    this.swimlanes,
    this.titleBuilder,
    required this.autoSelectFirst,
    required this.document,
    this.contextCardBuilders,
    this.queryStringIdParam = "id",
    this.embeddedDocument = false,
  });

  final GlobalKey<FormState> formKey;
  final DocumentList<T>? documentList;
  final DataGridConfig<T>? dataGridConfig;
  final ListGridConfig<T>? listGridConfig;
  final SwimlanesConfig<T>? swimlanes;
  final TitleBuilder<T>? titleBuilder;
  final Document<T> document;
  final String queryStringIdParam;
  final String collection;
  final bool autoSelectFirst;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final Query<T> Function(Query<T> query)? query;
  final SearchConfig<T>? searchConfig;
  final T Function() createNew;
  final T Function(T)? preSave;
  final T? Function(T)? preOpen;
  final String? Function(T)? createDocumentId;
  final List<ContextCardBuilder>? contextCardBuilders;
  final bool embeddedDocument;
  final ViewType initialViewType;

  late PreloadPageController preloadPageController;
  late PageController pageController;
  late TabController tabController;
  ViewType? _viewType;

  List<ViewType> get allowedViewTypes {
    //TODO: this needs to be cleaned up after listgrid is mature
    switch (initialViewType) {
      case ViewType.auto:
        List<ViewType> returnValue = [];
        if (listGridConfig != null) returnValue.add(ViewType.listgrid);
        if (documentList != null) returnValue.add(ViewType.list);
        if (dataGridConfig != null) returnValue.add(ViewType.grid);
        if (returnValue.isEmpty) returnValue.add(ViewType.none);
        return returnValue;
      case ViewType.listgrid:
        return [ViewType.listgrid];
      case ViewType.list:
        return [ViewType.list];
      case ViewType.grid:
        return [ViewType.grid];
      case ViewType.swimlanes:
        return [ViewType.swimlanes];
      case ViewType.none:
        return [];
    }
  }

  ViewType get currentViewType {
    if (_viewType == null) {
      return allowedViewTypes.first;
    }
    return _viewType!;
  }

  set currentViewType(ViewType viewType) {
    if (allowedViewTypes.contains(viewType)) {
      _viewType = viewType;
      notifyListeners();
    }
  }
}

enum ViewType { auto, list, grid, listgrid, swimlanes, none }

class Document<T> {
  Document({
    this.key,
    required this.documentTabsBuilder,
    this.extraActionButtons,
    this.contextCards,
    this.documentHeaderBuilder,
    this.scrollableHeader = true,
    this.autoSave = false,
    this.readOnly = false,
    this.showCreateButton = false,
    this.showCopyButton = false,
    this.showCloseButton = true,
    this.showEditToggleButton = false,
    this.showValidateButton = false,
    this.showSaveButton = true,
    this.showDeleteButton = false,
    this.prefetchTabs = true,
  });
  final Key? key;
  final DocumentTabsBuilder<T>? documentTabsBuilder;
  final DocumentHeaderBuilder<T>? documentHeaderBuilder;
  final List<ContextCardBuilder>? contextCards;
  final ExtraActionButtonsBuilder<T>? extraActionButtons;
  List<DocumentTab<T>>? activeTabs;
  final bool scrollableHeader;
  bool autoSave;
  bool readOnly;
  bool showCreateButton;
  bool showEditToggleButton;
  bool showDeleteButton;
  bool showCopyButton;
  bool showCloseButton;
  bool showValidateButton;
  bool showSaveButton;
  bool prefetchTabs;
}

class DocumentTab<T> {
  /// this is a fFrame Document Tab
  ///
  ///
  final DocumentTabBuilder<T> tabBuilder;
  final DocumentTabChildBuilder<T> childBuilder;
  final bool lockViewportScroll;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DocumentTab({
    required this.tabBuilder,
    required this.childBuilder,
    this.lockViewportScroll = false,
  });
}

class DocumentList<T> {
  const DocumentList({
    required this.builder,
    this.headerBuilder,
    this.footerBuilder,
    this.hoverSelect = false,
    this.showSeparator = true,
    this.showCreateButton = true,
    this.seperatorHeight = 1,
  });
  final DocumentListItemBuilder<T> builder;
  final DocumentListHeaderBuilder<T>? headerBuilder;
  final DocumentListFooterBuilder<T>? footerBuilder;
  final bool hoverSelect;
  final bool showSeparator;
  final bool showCreateButton;
  final double seperatorHeight;
}

class ListGrid<T> {
  const ListGrid({
    required this.builder,
    this.headerBuilder,
    this.footerBuilder,
    this.hoverSelect = false,
    this.showSeparator = true,
    this.showCreateButton = true,
    this.seperatorHeight = 1,
  });
  final DocumentListItemBuilder<T> builder;
  final DocumentListHeaderBuilder<T>? headerBuilder;
  final DocumentListFooterBuilder<T>? footerBuilder;
  final bool hoverSelect;
  final bool showSeparator;
  final bool showCreateButton;
  final double seperatorHeight;
}

enum HeaderType { header, footer }

enum QueryStringStrategy { replace, append }

class SearchConfig<T> {
  final List<SearchOption<T>> searchOptions;
  final String defaultField;
  late Map<String, SearchOption> optionMap;

  SearchConfig({required this.searchOptions, required this.defaultField});
}

class SearchOption<T> {
  final String caption;
  final String field;
  final SearchOptionType type;
  late String stringValue = "";
  late bool boolValue = true;
  late DateTime dateTimeValue = DateTime.now();
  late SearchOptionSortOrder sort;
  late SearchOptionComparisonOperator comparisonOperator;
  late bool isSelected = false;
  SearchOption({required this.caption, required this.field, required this.type, this.sort = SearchOptionSortOrder.none, this.comparisonOperator = SearchOptionComparisonOperator.equal});
}

enum SearchOptionType {
  string,
  boolean,
  datetime,
  date,
  time,
  int,
  user,
}

enum SearchOptionSortOrder {
  none,
  asc,
  desc,
}

enum SearchOptionComparisonOperator {
  lesser,
  greater,
  equal,
}
