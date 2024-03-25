part of '../../fframe.dart';

class DocumentScreen<T> extends StatelessWidget {
  DocumentScreen({
    super.key,
    required this.collection,
    required this.createNew,
    required this.titleBuilder,
    this.preSave,
    this.preOpen,
    this.createDocumentId,
    required this.fromFirestore,
    required this.toFirestore,
    this.documentList,
    this.dataGrid,
    this.listGrid,
    this.swimlanes,
    this.viewType = ViewType.auto,
    this.autoSelectFirst = false,
    this.query,
    this.searchConfig,
    required this.document,
    this.contextCardBuilders,
    this.queryStringIdParam = "id",
    this.documentScreenHeaderBuilder,
    this.documentScreenFooterBuilder,
    this.queryBuilder,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Query<T> Function(Query<T> query)? queryBuilder;
  final DocumentList<T>? documentList;
  final DataGridConfig<T>? dataGrid;
  final ListGridConfig<T>? listGrid;
  final SwimlanesConfig<T>? swimlanes;
  final ViewType viewType;
  final Query<T> Function(Query<T> query)? query;
  final SearchConfig<T>? searchConfig;
  final TitleBuilder<T> titleBuilder;
  final Document<T> document;
  final String queryStringIdParam;
  final String collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
  final Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final T Function() createNew;
  final T? Function(T)? preSave;
  final T Function(T)? preOpen;
  final bool autoSelectFirst;
  final String? Function(T)? createDocumentId;
  final List<ContextCardBuilder>? contextCardBuilders;
  final DocumentScreenHeaderBuilder? documentScreenHeaderBuilder;
  final DocumentScreenFooterBuilder? documentScreenFooterBuilder;

  @override
  Widget build(BuildContext context) {
    DocumentScreenConfig? parentDocumentScreenConfig = DocumentScreenConfig.of(context);

    FFrameUser fFrameUser = Fframe.of(context)!.user!;
    String? queryStringIdParam;
    bool? embeddedDocument;
    if (parentDocumentScreenConfig != null) {
      Console.log("This is an embedded instance of the DocumentScreen initalize FormCeption", scope: "fframeLog.DocumentScreen", level: LogLevel.fframe);
      if (queryStringIdParam == parentDocumentScreenConfig.documentConfig.queryStringIdParam) {
        queryStringIdParam = "child${toBeginningOfSentenceCase(parentDocumentScreenConfig.documentConfig.queryStringIdParam)}";
      }
      embeddedDocument = true;
    }

    return Stack(
      children: [
        Column(
          children: [
            if (documentScreenHeaderBuilder != null) documentScreenHeaderBuilder!(),
            Expanded(
              child: Form(
                key: formKey,
                child: DocumentScreenConfig(
                  fireStoreQueryState: FireStoreQueryState<T>(
                    collection: collection,
                    fromFirestore: fromFirestore,
                    initialQuery: query,
                    listQuery: queryBuilder,
                  ),
                  fFrameUser: fFrameUser,
                  documentConfig: DocumentConfig<T>(
                    formKey: formKey,
                    collection: collection,
                    documentList: documentList,
                    dataGridConfig: dataGrid,
                    listGridConfig: listGrid,
                    swimlanes: swimlanes,
                    initialViewType: viewType,
                    autoSelectFirst: autoSelectFirst,
                    queryStringIdParam: queryStringIdParam ?? this.queryStringIdParam,
                    createNew: createNew,
                    createDocumentId: createDocumentId,
                    preSave: preSave,
                    preOpen: preOpen,
                    document: document,
                    toFirestore: toFirestore,
                    fromFirestore: fromFirestore,
                    query: query,
                    searchConfig: searchConfig,
                    titleBuilder: titleBuilder,
                    contextCardBuilders: contextCardBuilders,
                    embeddedDocument: embeddedDocument ?? false,
                  ),
                  child: DocumentScreenLoader<T>(
                    key: ValueKey("DocumentScreenLoader_$collection"),
                  ),
                ),
              ),
            ),
            if (documentScreenFooterBuilder != null) documentScreenFooterBuilder!(),
          ],
        ),
        const DocumentBodyWatcher(),
      ],
    );
  }
}

class DocumentScreenConfig extends InheritedModel<DocumentScreenConfig> {
  // ignore: use_super_parameters
  const DocumentScreenConfig({
    super.key,
    required this.documentConfig,
    required this.fireStoreQueryState,
    required this.fFrameUser,
    required child,
  }) : super(child: child);

  final DocumentConfig documentConfig;
  final FireStoreQueryState fireStoreQueryState;
  final FFrameUser fFrameUser;

  static DocumentScreenConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DocumentScreenConfig>();
  }

  @override
  bool updateShouldNotify(DocumentScreenConfig oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(DocumentScreenConfig oldWidget, Set<DocumentScreenConfig> dependencies) {
    return true;
  }

  void snackbar({required BuildContext context, required String text, Icon? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: kBottomNavigationBarHeight,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            icon ?? const IgnorePointer(),
            Text(text),
            if (icon != null) const IgnorePointer(),
          ],
        ),
      ),
    );
  }

  void selectDocument<T>(BuildContext context, SelectedDocument<T> selectedDocument) {
    Console.log("*** DocumentScreen.selectDocument<T> is deprecated please replace is with selectedDocument.open() ***", scope: "DocumentScreen", level: LogLevel.dev, color: ConsoleColor.red);
    selectedDocument.open();
  }

  void create<T>({BuildContext? context}) {
    SelectedDocument.createNew(documentConfig: documentConfig);
  }

  save({required BuildContext context, bool closeAfterSave = false}) {
    SelectedDocument? selectedDocument = SelectionState.instance.activeDocument;
    if (selectedDocument != null) {
      if (closeAfterSave) {
        selectedDocument.update();
      } else {
        selectedDocument.save(context: context, closeAfterSave: closeAfterSave);
      }
    }
  }
}

class DocumentScreenLoader<T> extends StatefulWidget {
  final int rowsPerPage;

  const DocumentScreenLoader({super.key, this.rowsPerPage = -1});

  @override
  State<StatefulWidget> createState() => _DocumentScreenLoaderState<T>();
}

class _DocumentScreenLoaderState<T> extends State<DocumentScreenLoader<T>> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => navigationNotifier.markBuildDone());
  }

  @override
  Widget build(BuildContext context) {
    Console.log("Build DocumentScreenLoader: ${widget.key.toString()}", scope: "fframeLog.DocumentScreenLoader", level: LogLevel.fframe);
    DocumentConfig<T> documentConfig = DocumentScreenConfig.of(context)?.documentConfig as DocumentConfig<T>;

    // double columnWidth = 0;
    // if (documentConfig.currentViewType case ViewType.list) {
    //   if (documentConfig.documentList != null) {
    //     // Add this check
    //     columnWidth = documentConfig.documentList!.columnWidth;
    //   }
    // } else if (documentConfig.currentViewType case ViewType.listgrid) {
    //   columnWidth = documentConfig.listGridConfig!.columnSettings.first.columnWidth;
    // } else {
    //   columnWidth = 0;
    // }

    //Switches between view types
    return Consumer(builder: (context, ref, child) {
      ref.watch(targetStateProvider);

      //(pre-load the query-string. If any.
      QueryState queryState = ref.read(queryStateProvider);
      if (queryState.queryString.isNotEmpty && queryState.queryParameters!.containsKey(documentConfig.queryStringIdParam)) {
        SelectedDocument.load<T>(
          documentConfig: documentConfig,
          documentId: queryState.queryParameters![documentConfig.queryStringIdParam],
        );
      }

      switch (documentConfig.currentViewType) {
        // case ViewType.none:
        //   return DocumentBodyWatcher<T>(
        //     key: ValueKey("DocumentBodyWatcher_${documentConfig.collection}"),
        //   );
        case ViewType.list:
          SelectionState.instance.columnWidth = documentConfig.documentList?.columnWidth ?? 0;
          return Row(
            children: [
              DocumentListLoader<T>(
                key: ValueKey("DocumentListBuilder_${documentConfig.collection}"),
              ),
              Expanded(child: FRouter.of(context).emptyPage()),
            ],
          );
        case ViewType.grid:
          SelectionState.instance.columnWidth = documentConfig.dataGridConfig!.columnWidth;
          return SizedBox.expand(
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.topLeft,
                child: Stack(
                  children: [
                    FirestoreDataGrid<T>(
                      dataGridConfig: documentConfig.dataGridConfig!,
                      query: DocumentScreenConfig.of(context)!.fireStoreQueryState.currentQuery() as Query<T>,
                      rowsPerPage: documentConfig.dataGridConfig!.rowsPerPage,
                      dataRowHeight: documentConfig.dataGridConfig!.rowHeight,
                      documentConfig: documentConfig,
                    ),
                    if (documentConfig.documentList != null) DataGridToggle<T>(),
                  ],
                ),
              ),
            ),
          );
        case ViewType.listgrid:
          SelectionState.instance.columnWidth = documentConfig.listGridConfig!.columnWidth;
          return SizedBox.expand(
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.topLeft,
                child: FirestoreListGrid<T>(
                  documentConfig: documentConfig,
                  query: DocumentScreenConfig.of(context)!.fireStoreQueryState.currentQuery() as Query<T>,
                ),
              ),
            ),
          );
        case ViewType.swimlanes:
          SelectionState.instance.columnWidth = documentConfig.swimlanes!.columnWidth;
          return FirestoreSwimlanes<T>(
            documentConfig: documentConfig,
            query: DocumentScreenConfig.of(context)!.fireStoreQueryState.currentQuery() as Query<T>,
          );
        default:
          return Fframe.of(context)?.navigationConfig.errorPage.contentPane ??
              const Icon(
                Icons.error,
                color: Colors.red,
              );
      }
      // },
      // );
    });
  }
}

// class AutoFirstDocumentScreenLoader<T> extends StatefulWidget {
//   const AutoFirstDocumentScreenLoader({
//     super.key,
//     required this.documentConfig,
//   });

//   final DocumentConfig<T> documentConfig; // = DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;

//   @override
//   State<AutoFirstDocumentScreenLoader> createState() => _AutoFirstDocumentScreenLoaderState<T>();
// }

// class _AutoFirstDocumentScreenLoaderState<T> extends State<AutoFirstDocumentScreenLoader<T>> {
//   @override
//   Widget build(BuildContext context) {
//     Query<T> query = DocumentScreenConfig.of(context)!.fireStoreQueryState.currentQuery() as Query<T>;
//     return StreamBuilder<QuerySnapshot<T>>(
//       stream: query.snapshots(),
//       initialData: null,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<T>> querySnapshot) {
//         switch (querySnapshot.connectionState) {
//           case ConnectionState.none:
//           case ConnectionState.waiting:
//           case ConnectionState.done:
//             return FRouter.of(context).waitPage(context: context, text: "Loading first document");
//           case ConnectionState.active:
//             if (querySnapshot.hasData && querySnapshot.data != null && querySnapshot.data!.docs.isNotEmpty) {
//               QueryDocumentSnapshot<T> queryDocumentSnapshot = querySnapshot.data!.docs.first;
//               SelectionState<T> selectionState = DocumentScreenConfig.of(context)!.selectionState as SelectionState<T>;
//               selectionState.setState(SelectionState<T>(
//                 data: queryDocumentSnapshot.data(),
//                 docId: queryDocumentSnapshot.id,
//                 isNew: false,
//               ));
//               return DocumentBodyLoader<T>(
//                 key: ValueKey(queryDocumentSnapshot.id),
//               );
//             }

//             return FRouter.of(context).emptyPage();
//         }
//       },
//     );
//   }
// }
