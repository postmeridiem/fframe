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
  final Document document;
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
    required this.tabs,
    this.contextCards,
    this.autoSave = false,
    this.readOnly = false,
    this.showCopyButton = false,
    this.showEditToggleButton = false,
    this.showValidateButton = false,
    this.showSaveButton = true,
    this.showDeleteButton = false,
  });
  final Key? key;
  final List<DocumentTab<T>> tabs;
  final List<ContextCardBuilder>? contextCards;
  bool autoSave;
  bool readOnly;
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
  final DocumentTabChildBuilder childBuilder;
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
    this.autoSelectFirst = false,
    this.hoverSelect = false,
    this.showSeperator = true,
    this.showCreateButton = true,
    this.seperatorHeight = 1,
  });
  final DocumentListItemBuilder<T> builder;
  final Query<T> Function(Query<T> query)? queryBuilder;
  final bool autoSelectFirst;
  final bool hoverSelect;
  final bool showSeperator;
  final bool showCreateButton;
  final double seperatorHeight;
}

enum QueryStringStrategy { replace, append }

class SearchConfig<T> {
  final List<SearchOption<T>> searchOptions;

  SearchConfig({required this.searchOptions});
}

class SearchOption<T> {
  final String caption;
  final String field;
  final SearchOptionType type;
  late String stringValue = "";
  late bool boolValue = true;
  late DateTime dateTimeValue = DateTime.now();
  SearchOption({required this.caption, required this.field, required this.type});
}

enum SearchOptionType {
  string,
  boolean,
  datetime,
}
