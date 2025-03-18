import 'package:flutter/foundation.dart';
import 'package:fframe/fframe.dart';

class ListGridNotifier<T> extends ChangeNotifier {
  ListGridNotifier({
    required Query<T> initialQuery,
    required DocumentConfig<T> documentConfig,
  }) : super() {
    // not empty
    _searchString = '';
    _collectionCount = 0;
    _initialQuery = initialQuery;
    _currentQuery = initialQuery;
    // initialize the sorting object
    sortedColumnIndex = null;
    searchableColumns = [];
    // initialize the row selections

    _listGridConfig = documentConfig.listGridConfig;
    _columnSettings = _listGridConfig!.columnSettings;
    enableSearchBar = false;

    for (var i = 0; i < (_columnSettings.length); i++) {
      // get the settings for the current column
      ListGridColumn columnSetting = _columnSettings[i];

      // calculate the list of searchable fields for the search box
      if (columnSetting.searchable && columnSetting.fieldName != null) {
        enableSearchBar = true;
        searchableColumns.add(i);
      }
    }

    // initialize the current query, based on sorting and settings
    _queryBuilder();

    //update the collection count
    // _updateCollectionCount(query: _currentQuery as Query<T>);
  }

  set currentQuery(Query newQuery) {
    _currentQuery = newQuery as Query<T>;
  }

  Query<T> get currentQuery => _currentQuery as Query<T>;

  // final ListGridSearchConfig? searchConfig;
  // late List<ListGridColumn> columnSettings;
  late List<int> searchableColumns;
  late bool enableSearchBar;
  late String? _searchString;
  late int _collectionCount;
  Query<T>? _initialQuery;
  Query<T>? _currentQuery;
  late ListGridConfig<T>? _listGridConfig;
  late List<ListGridColumn<T>> _columnSettings;
  late int? sortedColumnIndex;
  final List<SelectedDocument<T>> _selectedDocuments = [];
  final List<DocumentSnapshot<T>> _allDocuments = []; // Store all fetched documents essential for client-side filtering

  String? get searchString {
    return _searchString;
  }

  set searchString(String? searchString) {
    //TODO JPM: add some kind of rate limiting
    if (searchString != null && searchString.isNotEmpty) {
      _searchString = searchString;
    } else {
      _searchString = null;
    }
    _queryBuilder();
  }

  Future<void> _fetchAllDocuments() async {
    // Fetch all documents from the initial query
    _allDocuments.clear();
    QuerySnapshot<T> querySnapshot = await _initialQuery!.get();
    _allDocuments.addAll(querySnapshot.docs);
  }

  void _queryBuilder() async {
    Query outputQuery = _initialQuery as Query<T>;

    // Fetch all documents if not already fetched
    if (_allDocuments.isEmpty) {
      await _fetchAllDocuments();
    }

    // handle sorting
    if (sortedColumnIndex != null) {
      ListGridColumn sortedColumn = _columnSettings[sortedColumnIndex!];
      Console.log(
        "fframeLog.ListGridNotifier: column sorted, search on the ${sortedColumn.fieldName!} column",
        level: LogLevel.fframe,
      );

      outputQuery = outputQuery.orderBy(sortedColumn.fieldName!, descending: sortedColumn.descending);
    }

    // Apply filtering on the client-side
    List<DocumentSnapshot<T>> filteredDocuments = _allDocuments;
    if (searchString != null && searchString!.isNotEmpty) {
      filteredDocuments = _filterDocuments(searchString!, filteredDocuments);
    }

    // Update the current query to reflect the filtered results
    _currentQuery = _initialQuery!.where('__name__', whereIn: filteredDocuments.map((doc) => doc.id).toList());

    Console.log(
      "fframeLog.ListGridNotifier: ${outputQuery.parameters.toString()}",
      level: LogLevel.fframe,
    );

    // the query has changed; recalculate the result collection count
    _updateCollectionCount(query: _currentQuery as Query<T>);

    // notify the listeners that a redraw is needed
    notifyListeners();
  }

  List<DocumentSnapshot<T>> _filterDocuments(
    String searchString,
    List<DocumentSnapshot<T>> documents,
  ) {
    List<DocumentSnapshot<T>> filteredDocs = [];
    for (DocumentSnapshot<T> doc in documents) {
      bool match = false;
      for (int searchableColumnIndex in searchableColumns) {
        ListGridColumn currentColumn = _columnSettings[searchableColumnIndex];
        if (currentColumn.fieldName != null) {
          String fieldName = currentColumn.fieldName!;
          dynamic fieldValue = doc.get(fieldName);

          if (fieldValue != null) {
            String stringValue = fieldValue.toString();
            String curSearch = searchString;

            if (currentColumn.searchMask != null) {
              if (currentColumn.searchMask!.toLowerCase) {
                stringValue = stringValue.toLowerCase();
                curSearch = curSearch.toLowerCase();
              }
              curSearch = curSearch.replaceAll(
                currentColumn.searchMask!.from,
                currentColumn.searchMask!.to,
              );
            }
            // Determine if we should use startsWith or contains based on user input
            if (currentColumn.startsWithSearch) {
              // Use startsWith
              if (stringValue.toLowerCase().startsWith(curSearch.toLowerCase())) {
                match = true;
                break;
              }
            } else {
              // Use contains
              if (stringValue.contains(curSearch)) {
                match = true;
                break;
              }
            }
          }
        }
      }
      if (match) {
        filteredDocs.add(doc);
      }
    }
    return filteredDocs;
  }

  void sortColumn({required int columnIndex, bool descending = false}) {
    // get the config for the selected column
    ListGridColumn selectedColumn = _columnSettings.where((element) => element.columnIndex == columnIndex).first;

    if (columnIndex == sortedColumnIndex && descending == selectedColumn.descending) {
      // this column and sort direction were already selected. user is deselecting sort
      sortedColumnIndex = null;
    } else {
      // change the sort to the selected state
      // set the currently sorted column to this one
      sortedColumnIndex = columnIndex;

      // set the columns search direction to the input
      _columnSettings[columnIndex].descending = descending;

      Console.log(
        "Sorting column: ${selectedColumn.fieldName} (column: ${columnIndex + 1}) ${descending ? "descending" : "ascending"}",
        scope: "fframeLog.ListGrid",
        level: LogLevel.fframe,
      );
    }

    // run the query builder to interpret the new sorting settings
    // and call notifyListeners
    _queryBuilder();
  }

  int? get sortedColumnIndexer {
    return sortedColumnIndex;
  }

  int get collectionCount {
    return _collectionCount;
  }

  List<SelectedDocument<T>> get selectedDocuments {
    return _selectedDocuments;
  }

  int get selectionCount {
    return _selectedDocuments.isNotEmpty ? _selectedDocuments.length : 0;
  }

  void selectRow({required SelectedDocument<T> selectedDocument}) {
    _selectedDocuments.add(selectedDocument);
    notifyListeners();
  }

  void unselectRow({required SelectedDocument<T> unSelectedDocument}) {
    _selectedDocuments.removeWhere((selectedDocument) => selectedDocument.documentId == unSelectedDocument.documentId);
    notifyListeners();
  }

  set collectionCount(int collectionCount) {
    _collectionCount = collectionCount;
    notifyListeners();
  }

  void _updateCollectionCount({required Query<T> query}) async {
    AggregateQuerySnapshot snapshot = await query.count().get();
    int collectionCount = snapshot.count!;
    _collectionCount = collectionCount;
  }

  void update() {
    notifyListeners();
  }
}
