part of fframe;

class DocumentConfig<T> {
  DocumentConfig({
    required this.formKey,
    required this.collection,
    required this.createNew,
    this.createDocumentId,
    required this.fromFirestore,
    required this.toFirestore,
    this.query,
    this.searchConfig,
    this.documentList,
    this.titleBuilder,
    required this.document,
    this.extraActionButtons,
    this.contextCardBuilders,
    this.queryStringIdParam = "id",
    this.embeddedDocument = false,
  });

  final GlobalKey<FormState> formKey;
  final DocumentList<T>? documentList;
  final TitleBuilder<T>? titleBuilder;
  final Document<T> document;
  final List<IconButton>? extraActionButtons;
  final String queryStringIdParam;
  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final Query<T> Function(Query<T> query)? query;
  final SearchConfig<T>? searchConfig;
  final T Function() createNew;
  final String? Function(T)? createDocumentId;
  final List<ContextCardBuilder>? contextCardBuilders;
  final bool embeddedDocument;

  late PreloadPageController preloadPageController;
  late TabController tabController;
}

class Document<T> {
  Document({
    this.key,
    required this.documentTabsBuilder,
    this.contextCards,
    this.documentHeaderBuilder,
    this.autoSave = false,
    this.readOnly = false,
    this.showCreateButton = false,
    this.showCopyButton = false,
    this.showEditToggleButton = false,
    this.showValidateButton = false,
    this.showSaveButton = true,
    this.showDeleteButton = false,
  });
  final Key? key;
  final DocumentTabsBuilder<T>? documentTabsBuilder;
  final DocumentHeaderBuilder<T>? documentHeaderBuilder;
  final List<ContextCardBuilder>? contextCards;
  List<DocumentTab<T>>? activeTabs;
  bool autoSave;
  bool readOnly;
  bool showCreateButton;
  bool showEditToggleButton;
  bool showDeleteButton;
  bool showCopyButton;
  bool showValidateButton;
  bool showSaveButton;
}

class DocumentTab<T> {
  /// this is a fFrame Document Tab
  ///
  ///
  final DocumentTabBuilder<T> tabBuilder;
  final DocumentTabChildBuilder<T> childBuilder;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DocumentTab({
    required this.tabBuilder,
    required this.childBuilder,
  });
}

class DocumentList<T> {
  const DocumentList({
    required this.builder,
    this.queryBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.autoSelectFirst = false,
    this.hoverSelect = false,
    this.showSeparator = true,
    this.showCreateButton = true,
    this.seperatorHeight = 1,
  });
  final DocumentListItemBuilder<T> builder;
  final Query<T> Function(Query<T> query)? queryBuilder;
  final DocumentListHeaderBuilder<T>? headerBuilder;
  final DocumentListFooterBuilder<T>? footerBuilder;
  final bool autoSelectFirst;
  final bool hoverSelect;
  final bool showSeparator;
  final bool showCreateButton;
  final double seperatorHeight;
}

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
