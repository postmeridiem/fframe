part of fframe;

class DocumentConfig<T> {
  DocumentConfig({
    required this.collection,
    required this.createNew,
    this.createDocumentId,
    required this.fromFirestore,
    required this.toFirestore,
    this.documentList,
    // this.documentBuilder,
    this.titleBuilder,
    required this.document,
    this.extraActionButtons,
    this.contextCardBuilders,
    this.queryStringIdParam = "id",
  });

  final DocumentList<T>? documentList;
  // final DocumentBuilder<T>? documentBuilder;
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
}

class Document<T> {
  Document({
    this.key,
    required this.tabs,
    this.contextCards,
    this.autoSave = false,
  });
  final Key? key;
  final List<DocumentTab> tabs;
  final List<ContextCardBuilder>? contextCards;
  bool autoSave;
}

class DocumentTab<T> {
  /// this is a fFrame Document Tab
  ///
  ///
  final DocumentTabBuilder<T> tabBuilder;
  final DocumentTabChildBuilder childBuilder;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

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
