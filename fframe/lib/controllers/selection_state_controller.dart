part of '../fframe.dart';

enum SelectionStateViewType {
  maximized,
  minimized,
  closed,
  custom,
}

class SelectionStateTracker<T> {
  SelectionStateTracker({
    required this.selectedDocument,
    required this.trackerId,
    required this.queryParameters,
    this.viewType = SelectionStateViewType.maximized,
  }) {
    selectedDocument.selectionStateTracker = this;
  }
  SelectionStateViewType viewType = SelectionStateViewType.maximized;
  final String trackerId;
  final SelectedDocument<T> selectedDocument;
  final Map<String, String> queryParameters;
  int minimizedPosition = 0;

  DocumentBody<T> get documentBody => DocumentBody<T>(
        selectedDocument: selectedDocument,
        documentConfig: selectedDocument.documentConfig,
      );

  String documentTitle({required BuildContext context}) {
    return selectedDocument.documentConfig.documentTitle(context, selectedDocument.data);
  }

  Widget titleIcon() {
    //TODO
    return const Icon(Icons.no_crash_outlined);
  }

  clearQueryParameters() {
    queryParameters.clear();
  }

  void updateQueryString(Map<String, String> queryString) {
    for (var queryStringElement in queryString.entries) {
      queryParameters[queryStringElement.key] = queryStringElement.value;
    }
  }

  setQueryParameter({required String key, required String value}) {
    queryParameters[key] = value;
  }

  clearQueryParameter({required String key}) {
    if (queryParameters.containsKey(key)) {
      queryParameters.remove(key);
    }
  }

  String? queryStringParam(String key) => queryParameters[key];

  String get queryString {
    return queryParameters.entries.map((queryParameter) => "${queryParameter.key}=${queryParameter.value}").join("&");
  }
}

class SelectionState with ChangeNotifier {
  static final SelectionState instance = SelectionState._internal();
  SelectionState._internal();
  final Map<String, SelectionStateTracker> _selectionState = {};

  SelectionState();

  EdgeInsets _padding = EdgeInsets.zero;

  set padding(EdgeInsets padding) {
    _padding = padding;
    notifyListeners();
  }

  EdgeInsets get padding => _padding;

  SelectionStateTracker? get activeTracker {
    return _selectionState.firstWhereOrNull(
      (key, tracker) => tracker.viewType == SelectionStateViewType.maximized,
    );
  }

  List<SelectionStateTracker> get minimizedDocuments {
    return _selectionState.values.where((selectionStateTracker) {
      var result = selectionStateTracker.viewType == SelectionStateViewType.minimized;
      return result;
    }).toList();
  }

  SelectedDocument? get activeDocument {
    SelectionStateTracker? activeTracker = this.activeTracker;
    if (activeTracker == null) return null;
    return activeTracker.selectedDocument;
  }

  String? get activeDocumentId {
    SelectedDocument? activeDocument = this.activeDocument;
    if (activeDocument == null) return null;
    return activeDocument.trackerId;
  }

  String? get activeDocumentCollection {
    SelectedDocument? activeDocument = this.activeDocument;
    if (activeDocument == null) return null;
    return activeDocument.collection;
  }

  clear() {
    _selectionState.clear();
    NavigationNotifier.instance.processRouteInformation();
    // NavigationNotifier.instance.processRouteInformation(queryState: QueryState(queryParameters: null));
    // notifyListeners();
  }

  selectDocument<T>(SelectedDocument<T> selectedDocument) {
    //Cannot keep a pendingUri on top of any other load
    pendingUri = null;
    // NavigationNotifier.instance local = NavigationNotifier.instance.instance;
    // if (NavigationNotifier.instance.instance.isBuilding) {
    //   debugger();
    // }

    String trackerId = selectedDocument.trackerId;

    //Minimize any full screen document

    if (selectedDocument.documentConfig.mdi == true) {
      _minimize(viewType: SelectionStateViewType.maximized);
    } else {
      activeDocument?.close(skipWarning: true);
    }

    if (_selectionState.containsKey(trackerId)) {
      //The document is already loaded, but possibly with the wrong viewType
      maximizeDocument(selectedDocument);
    } else {
      //Load and activate the document

      // //Minimize any full screen document
      // _minimize(viewType: SelectionStateViewType.maximized);

      //Add the selected document to the selectionState, if needed
      _selectionState.putIfAbsent(
        trackerId,
        () => SelectionStateTracker<T>(
          selectedDocument: selectedDocument,
          trackerId: trackerId,
          queryParameters: {selectedDocument.documentConfig.queryStringIdParam: selectedDocument.documentId},
        ),
      );

      if (_selectionState.length > 8) _selectionState.remove(_selectionState.entries.first.key);

      //Update the route
      NavigationNotifier.instance.processRouteInformation();

      notifyListeners();
    }
  }

  _minimize({required SelectionStateViewType viewType}) {
    _selectionState.forEach((String key, SelectionStateTracker selectionStateTracker) {
      if (selectionStateTracker.viewType == viewType) {
        selectionStateTracker.viewType = SelectionStateViewType.minimized;
      }
    });
    NavigationNotifier.instance.processRouteInformation();
  }

  maximizeDocument<T>(SelectedDocument<T> selectedDocument) {
    //Check if hte document is not already the active one
    String? activeDocumentId = this.activeDocumentId;
    String trackerId = selectedDocument.trackerId;
    if (activeDocumentId == null || trackerId != activeDocumentId) {
      //Minimize any full screen document
      _minimize(viewType: SelectionStateViewType.maximized);
      // QueryState.instance.queryParameters = {selectedDocument.documentConfig.queryStringIdParam: selectedDocument.documentId};
      NavigationNotifier.instance.processRouteInformation();

      //Activate the selected document
      _selectionState[trackerId]?.viewType = SelectionStateViewType.maximized;
      // notifyListeners();
    }
    NavigationNotifier.instance.processRouteInformation();
  }

  minimizeDocument<T>(SelectedDocument<T> selectedDocument) {
    //Minimize the selected document
    if (_changeViewType(selectedDocument: selectedDocument, viewType: SelectionStateViewType.minimized)) {
      // QueryState.instance.queryParameters = null;
      NavigationNotifier.instance.processRouteInformation();
      // notifyListeners();
    }
    NavigationNotifier.instance.processRouteInformation();
  }

  bool _changeViewType<T>({required SelectedDocument<T> selectedDocument, required SelectionStateViewType viewType}) {
    //Minimize the selected document
    String trackerId = selectedDocument.trackerId;
    if (_selectionState.containsKey(trackerId)) {
      _selectionState[trackerId]?.viewType = viewType;
      NavigationNotifier.instance.processRouteInformation();
      return true;
    }
    return false;
  }

  closeDocument<T>(SelectedDocument<T> selectedDocument) {
    if (selectedDocument.trackerId == activeDocument?.trackerId) {
      // TODO: Perform a dirty document check
    }
    if (_selectionState.containsKey(selectedDocument.trackerId)) {
      _selectionState.remove(selectedDocument.trackerId);
      notifyListeners();
    }
    NavigationNotifier.instance.processRouteInformation();
  }

  closeActiveDocument() {
    SelectedDocument? selectedDocument = activeDocument;
    if (selectedDocument != null) {
      closeDocument(selectedDocument);
    }
  }

  closeAllDocuments() {
    _selectionState.clear();
  }

  closeSelectedDocument<T>(SelectedDocument<T> selectedDocument) {
    closeDocument(selectedDocument);
  }

  String getTrackerId<T>({
    required SelectionStateTracker<T> selectionStateTracker,
    // required String documentId,
  }) {
    return selectionStateTracker.selectedDocument.trackerId;
    // return "${documentConfig.collection}/$documentId";
  }

  bool isDocumentLoaded<T>({
    required DocumentConfig<T> documentConfig,
    required String documentId,
  }) {
    return _selectionState.containsKey(SelectedDocument(documentConfig: documentConfig, id: documentId).trackerId);
  }

  //Navigation and QueryString related

  Uri? pendingUri;
  SelectionState fromUri({required Uri uri}) {
    pendingUri = uri;
    return this;
  }

  String get queryString {
    if (activeTracker != null) {
      return activeTracker!.queryString;
    }
    return "";
    // return _queryParameters?.entries.map((queryParameter) => "${queryParameter.key}=${queryParameter.value}").join("&") ?? "";
  }

  Map<String, String>? get queryParameters {
    return activeTracker?.queryParameters;
  }

  String? queryStringParam(String key) => activeTracker?.queryStringParam(key);

  void clearQueryParameters() {
    closeActiveDocument();
  }

  void updateQueryString(Map<String, String> queryString) {
    activeTracker?.updateQueryString(queryString);
  }

  // //This is triggered when the URL changes
  // processRouteInformation() {
  //   debugger();
  // }
}

class SelectedDocument<T> {
  final DocumentConfig<T> documentConfig;
  late DocumentSnapshot<T>? documentSnapshot;
  late List<DocumentTab<T>> documentTabs;
  late Type type;
  late List<int> _fingerPrint;
  String? _id;
  T? _data;
  bool? _readOnly;
  bool? _isNew;

  SelectedDocument({
    required id,
    required this.documentConfig,
    this.documentSnapshot,
    T? data,
    bool readOnly = false,
    bool isNew = false,
  }) {
    _id = id;

    if (data != null) {
      //Data has been injected;
      _data = data;
    } else if (this.documentSnapshot != null) {
      //There is a documentSnapshot which should hold dagta
      _data = (documentSnapshot!.exists) ? documentSnapshot!.data() : null;
    } else if (id != _createNewDocumentId(data: data)) {
      //There is a valid id, yet no data;
      // throw ("Invalid instantiation, please insert data node or documentSnapshot node");
    } else {
      _data = documentConfig.createNew();
    }
    _readOnly = readOnly;
    _isNew = isNew;
    if (isNew) {
      _id = _createNewDocumentId();
    }
  }

  late SelectionStateTracker selectionStateTracker;
  String get trackerId => "${documentConfig.collection}/$documentId";

  // Getter for _data
  T get data => _data!;

  bool get readOnly => _readOnly!;

  bool get isNew => _isNew!;

  String get documentId {
    _id = _id ?? _createNewDocumentId();
    return _id!;
  }

  String get collection => documentConfig.collection;

  String get queryParameter => "${documentConfig.queryStringIdParam}?$documentId";

  @override
  toString() {
    return "firestore:/${this.collection}/$documentId";
  }

  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      _readOnly = readOnly;
    }
  }

  // Setter for _data
  set data(T? newData) {
    if (newData != null) {
      documentConfig.toFirestore(newData, null);
      _data = newData;
    }
  }

  List<int> _createFingerPrint() {
    Map<String, dynamic> sortedMap = Map.fromEntries(documentConfig.toFirestore(data, SetOptions(merge: true)).entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    List<int> bytes = utf8.encode(sortedMap.toString());
    return md5.convert(bytes).bytes;
  }

  SelectedDocument<T> open() {
    //Run the pre-open script (if any)
    if (documentConfig.preOpen != null) {
      this.data = documentConfig.preOpen!(data);
    }
    _fingerPrint = _createFingerPrint();

    SelectionState.instance.selectDocument<T>(this);
    return this;
  }

  bool get isDirty {
    List<int> currentFingerprint = _createFingerPrint();

    if (currentFingerprint.length != _fingerPrint.length) {
      return true; // Fingerprints are different (lengths don't match)
    }

    for (int i = 0; i < currentFingerprint.length; i++) {
      if (currentFingerprint[i] != _fingerPrint[i]) {
        return true; // Fingerprints are different
      }
    }

    return false;
  }

  snackbar({required BuildContext context, required SnackBar snackbar}) {
    Fframe.of(context)!.showSnackBar(
      context: context,
      snackBar: snackbar,
    );
  }

  delete({required BuildContext context}) async {
    if (isNew) return;
    bool dialogResult = await (confirmationDialog(
        context: context,
        cancelText: L10n.string(
          "iconbutton_document_delete_cancel",
          placeholder: "Cancel",
          namespace: 'fframe',
        ),
        continueText: L10n.string(
          "iconbutton_document_delete_continue",
          placeholder: "Continue",
          namespace: 'fframe',
        ),
        titleText: L10n.string(
          "iconbutton_document_delete_title",
          placeholder: "Delete this document",
          namespace: 'fframe',
        ),
        child: SizedBox(
          height: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.warning,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10n.string(
                      "iconbutton_document_delete1",
                      placeholder: "Delete this document?",
                      namespace: 'fframe',
                    ),
                  ),
                  Text(
                    L10n.string(
                      "iconbutton_document_delete2",
                      placeholder: "This operation cannot be undone.",
                      namespace: 'fframe',
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));

    if (dialogResult == true) {
      SaveState saveResult = await DatabaseService<T>().deleteDocument(
        collection: collection,
        documentId: documentId,
        fromFirestore: documentConfig.fromFirestore,
        toFirestore: documentConfig.toFirestore,
      );
      if (saveResult.result == true && context.mounted) {
        close(context: context, skipWarning: true);
      } else {
        //show the error
        if (!context.mounted) return;
        Fframe.of(context)!.showSnackBar(
          context: context,
          message: saveResult.errorMessage!,
          icon: Icon(
            Icons.error,
            color: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  close({BuildContext? context, bool skipWarning = false}) async {
    if (isDirty == false || this.readOnly == true || skipWarning == true) {
      SelectionState.instance.closeSelectedDocument(this);
      return;
    }
    if (await (confirmationDialog(
            context: context!,
            cancelText: L10n.string(
              "iconbutton_document_close_cancel",
              placeholder: "Cancel",
            ),
            continueText: L10n.string(
              "iconbutton_document_close_continue",
              placeholder: "Continue",
            ),
            titleText: L10n.string(
              "iconbutton_document_close_title",
              placeholder: "Close this document",
            ),
            child: SizedBox(
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.question_mark,
                      color: Colors.yellowAccent.shade200,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10n.string(
                          "iconbutton_document_close1",
                          placeholder: "Close this document?",
                        ),
                      ),
                      Text(
                        L10n.string(
                          "iconbutton_document_close2",
                          placeholder: "Any changes made to the document will be lost.",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))) ==
        true) {
      SelectionState.instance.closeSelectedDocument(this);
    }
  }

  copy({required BuildContext context}) {
    SelectedDocument<T> clone = SelectedDocument<T>.clone(documentConfig: documentConfig, data: data);
    //Todo: Check if new doc flag is proper
    SelectionState.instance.selectDocument(clone);
  }

  update({T? data}) async {
    String? docId = documentId;
    if (isNew == true) {
      docId = _createNewDocumentId(data: data as T);
    }
    if (data != null) {
      _data = data;
    }
    isNew
        ? await DatabaseService<T>().createDocument(
            collection: documentConfig.collection,
            documentId: docId,
            data: _data! as T,
            fromFirestore: documentConfig.fromFirestore,
            toFirestore: documentConfig.toFirestore,
          )
        : await DatabaseService<T>().updateDocument(
            collection: documentConfig.collection,
            documentId: docId,
            data: _data! as T,
            fromFirestore: documentConfig.fromFirestore,
            toFirestore: documentConfig.toFirestore,
          );
    //Update the fingerprint
    _fingerPrint = _createFingerPrint();
  }

  save({required BuildContext context, bool closeAfterSave = true, T? data}) async {
    if (validate(context: context, moveToTab: true) == -1) {
      String? docId = documentId;

      if (data == null && _data != null) {
        //Accept the class level data
        data = _data;
      } else if (data == null) {
        throw ("Unable to save a document that does not hold data.");
      }

      if (isNew == true) {
        docId = _createNewDocumentId(data: data as T);
      }

      //optional presave script
      if (documentConfig.preSave != null) {
        T? newData = documentConfig.preSave!(_data! as T);
        if (newData == null) return; //Cancel save
        _data = newData;
      }
      Console.log("Save item $docId in collection ${documentConfig.collection}", scope: "fframeLog.DocumentScreen.save", level: LogLevel.dev);

      SaveState saveResult = isNew
          ? await DatabaseService<T>().createDocument(
              collection: documentConfig.collection,
              documentId: docId,
              data: _data! as T,
              fromFirestore: documentConfig.fromFirestore,
              toFirestore: documentConfig.toFirestore,
            )
          : await DatabaseService<T>().updateDocument(
              collection: documentConfig.collection,
              documentId: docId,
              data: _data! as T,
              fromFirestore: documentConfig.fromFirestore,
              toFirestore: documentConfig.toFirestore,
            );

      if (saveResult.result) {
        //Success
        Console.log("Save was successfull", scope: "fframeLog.DocumentScreen.save", level: LogLevel.dev);
        _isNew = false;
        if (closeAfterSave) {
          if (context.mounted) {
            close(context: context, skipWarning: true);
          }
        } else {
          //Update the fingerprint
          _fingerPrint = _createFingerPrint();
        }
      } else {
        Console.log("ERROR: Save failed", scope: "fframeLog.DocumentScreen.save", level: LogLevel.prod);
        if (context.mounted) {
          Fframe.of(context)!.showSnackBar(
            context: context,
            message: saveResult.errorMessage!,
            icon: Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  int validate({required BuildContext context, bool showPopup = false, bool moveToTab = false}) {
    int invalidTab = documentTabs
        .map((DocumentTab tab) {
          bool result = tab.formKey.currentState!.validate();
          Console.log("Tab ${documentConfig.tabController.index} validated: $result", scope: "fframeLog.DocumentScreen.validate", level: LogLevel.dev);
          return tab.formKey.currentState!.validate();
        })
        .toList()
        .indexWhere((bool validationResult) => validationResult == false);
    // .toDouble();
    if (invalidTab == -1) {
      if (showPopup) {
        snackbar(
          context: context,
          snackbar: SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  color: Colors.green.shade900,
                ),
                const SizedBox(width: 10),
                Text(L10n.string(
                  'validator_success',
                  placeholder: "Form is valid",
                )),
              ],
            ),
          ),
        );
      }
    } else {
      if (showPopup) {
        snackbar(
          context: context,
          snackbar: SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red.shade900,
                ),
                const SizedBox(width: 10),
                Text(L10n.string(
                  'validator_fail',
                  placeholder: "Form is invalid",
                )),
              ],
            ),
          ),
        );
      }
      if (documentConfig.tabController.index != invalidTab || moveToTab) {
        documentConfig.tabController.animateTo(invalidTab);
        // _documentConfig.preloadPageController.animateTo(invalidTab, duration: const Duration(microseconds: 250), curve: Curves.easeOutCirc);
      }
    }
    return invalidTab.toInt();
  }

  List<IconButton>? iconButtons(BuildContext context) {
    Document<T> document = documentConfig.document;
    List<IconButton>? iconButtons = [];

    // if (document.showCloseButton) {
    //   iconButtons.add(
    //     IconButton(
    //       tooltip: L10n.string(
    //         "iconbutton_document_close",
    //         placeholder: "Close this document",
    //         namespace: 'fframe',
    //       ),
    //       icon: Icon(
    //         Icons.close,
    //         color: Theme.of(context).indicatorColor,
    //       ),
    //       onPressed: () {
    //         close(context: context);
    //       },
    //     ),
    //   );
    // }

    if (!isNew) {
      if (document.showDeleteButton) {
        iconButtons.add(
          IconButton(
            tooltip: L10n.string(
              "iconbutton_document_delete",
              placeholder: "Delete this document",
              namespace: 'fframe',
            ),
            icon: Icon(
              Icons.delete_forever,
              color: Theme.of(context).indicatorColor,
            ),
            onPressed: () {
              delete(context: context);
            },
          ),
        );
      }

      if (document.showCopyButton) {
        iconButtons.add(
          IconButton(
            tooltip: L10n.string(
              "iconbutton_document_copy",
              placeholder: "Copy this document",
              namespace: 'fframe',
            ),
            icon: Icon(
              Icons.copy_outlined,
              color: Theme.of(context).indicatorColor,
            ),
            onPressed: () {
              copy(context: context);
            },
          ),
        );
      }

      if (document.showEditToggleButton) {
        iconButtons.add(
          IconButton(
            tooltip: L10n.string(
              "iconbutton_document_edit",
              placeholder: "Edit this document",
              namespace: 'fframe',
            ),
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).indicatorColor,
            ),
            onPressed: () {
              readOnly = !readOnly;
            },
          ),
        );
      }
    }

    if (readOnly == false) {
      if (document.showValidateButton) {
        iconButtons.add(
          IconButton(
            tooltip: L10n.string(
              "iconbutton_document_validate",
              placeholder: "Validate this document",
              namespace: 'fframe',
            ),
            icon: Icon(
              Icons.check,
              color: Theme.of(context).indicatorColor,
            ),
            onPressed: () {
              validate(context: context, showPopup: true);
            },
          ),
        );
      }
      if (document.showSaveButton) {
        iconButtons.add(
          IconButton(
            tooltip: L10n.string(
              "iconbutton_document_save",
              placeholder: "Save this document",
              namespace: 'fframe',
            ),
            icon: Icon(
              Icons.save,
              color: Theme.of(context).indicatorColor,
            ),
            onPressed: () {
              save(context: context);
            },
          ),
        );
      }
    }
    return iconButtons.reversed.toList();
  }

  String _createNewDocumentId({T? data}) {
    String? documentId;
    //See if one can be generated from the data;
    if (documentConfig.createDocumentId != null && data != null) {
      documentId = documentConfig.createDocumentId!(data);
    } else if (documentConfig.createDocumentId != null && _data != null) {
      documentId = documentConfig.createDocumentId!(_data as T);
    }
    return documentId ??= DatabaseService<T>().generateDocId(collection: documentConfig.collection);
  }

  factory SelectedDocument.createNew({
    required DocumentConfig<T> documentConfig,
    bool openAfterCreate = true,
  }) {
    T creationData = documentConfig.createNew();
    String? createDocumentId = documentConfig.createDocumentId!(creationData);
    SelectedDocument<T> selectedDocument = SelectedDocument<T>(
      documentConfig: documentConfig,
      id: createDocumentId ?? "new",
      data: creationData, //This goes back to the intantiator
      isNew: true,
    );
    return openAfterCreate ? selectedDocument.open() : selectedDocument;
  }

  factory SelectedDocument.clone({
    required DocumentConfig<T> documentConfig,
    required T data,
  }) {
    return SelectedDocument<T>(
      documentConfig: documentConfig,
      id: null,
      data: data, //This goes back to the intantiator
      isNew: true,
    );
  }

  SelectedDocument<T> select() {
    return this.open();
  }

  static Future<SelectedDocument<T>?> load<T>({
    required DocumentConfig<T> documentConfig,
    required String id,
  }) async {
    // bool isAlreadyLoaded = SelectionState.instance.isDocumentLoaded(documentConfig: documentConfig, documentId: id);
    // if (isAlreadyLoaded) {
    //   debugPrint("Document is already in scope");
    return Future.value(DatabaseService<T>().selectedDocument(documentId: id, documentConfig: documentConfig)).then((SelectedDocument<T>? selectedDocument) {
      if (selectedDocument != null) {
        return selectedDocument.open();
      }
      throw ("Document $id could not be loaded from ${documentConfig.collection}");
    }).onError((error, stackTrace) => SelectionState.instance.clear());
    // } else {
    //   debugPrint("Document must be read from the database");

    // }
    // return null;
  }
}
