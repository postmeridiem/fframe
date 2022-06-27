part of fframe;

class DocumentConfig<T> {
  DocumentConfig({
    required this.formKey,
    required this.collection,
    required this.createNew,
    this.createDocumentId,
    required this.fromFirestore,
    required this.toFirestore,
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
  final T Function() createNew;
  final String? Function(T)? createDocumentId;
  final List<ContextCardBuilder>? contextCardBuilders;
  final bool embeddedDocument;
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
  final List<DocumentTab> tabs;
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

  DocumentTab({
    required this.tabBuilder,
    required this.childBuilder,
  });
}

class DocumentList<T> {
  const DocumentList({
    required this.builder,
    this.queryBuilder,
  });
  final DocumentListItemBuilder<T> builder;
  final Query<T> Function(Query<T> query)? queryBuilder;
}

enum QueryStringStrategy { replace, append }
