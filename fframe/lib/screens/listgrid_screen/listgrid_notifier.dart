import 'package:fframe/extensions/extensions.dart';
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

    assert(
      _listGridConfig!.searchAsContains || searchableColumns.length <= 1,
      'Multiple searchable columns are only supported when `searchAsContains` is true. Please enable `searchAsContains` in ListGridConfig or mark only one column as searchable.',
    );

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

  void _queryBuilder() {
    Query outputQuery = _initialQuery as Query<T>;

    // handle sorting
    if (sortedColumnIndex != null) {
      ListGridColumn sortedColumn = _columnSettings[sortedColumnIndex!];
      Console.log(
        "fframeLog.ListGridNotifier: column sorted, search on the ${sortedColumn.fieldName!} column",
        level: LogLevel.fframe,
      );

      outputQuery = outputQuery.orderBy(sortedColumn.fieldName!, descending: sortedColumn.descending);

      if (_columnSettings[sortedColumnIndex!].fieldName != null) {
        String fieldName = _columnSettings[sortedColumnIndex!].fieldName!;
        outputQuery = outputQuery.startsWith(fieldName, searchString!);
      }
    } else {
      if (searchableColumns.isNotEmpty) {
        if (searchString != null && searchString!.isNotEmpty) {
          // A search string is present.
          Console.log("fframeLog.ListGridNotifier: searching for: $searchString");

          // For server-side searches (`startsWith`), Firestore requires the query to be
          // ordered by the same field used in the range filter. We use the first
          // available searchable column as the primary one for this purpose.
          // The assertion in the constructor ensures that for server-side searches,
          // there is only one searchable column configured.
          final ListGridColumn primarySearchColumn = _columnSettings[searchableColumns.first];

          if (primarySearchColumn.fieldName != null) {
            String curSearch = searchString!;
            String fieldName = primarySearchColumn.fieldName!;
            outputQuery = outputQuery.orderBy(fieldName, descending: primarySearchColumn.descending);

            if (primarySearchColumn.searchMask == null) {
              // For a "startsWith" search, apply the filter directly to the query.
              // When 'searchAsContains' is true, this is skipped. The filtering is handled on the client-side
              // in `ListGridEndless`, which allows for checking multiple columns.
              if (_listGridConfig != null && !_listGridConfig!.searchAsContains) {
                outputQuery = outputQuery.startsWith(fieldName, curSearch);
              }
            } else {
              // Apply search mask if one is configured.
              if (primarySearchColumn.searchMask!.toLowerCase) {
                curSearch = curSearch.toLowerCase();
              }
              outputQuery = outputQuery.startsWith(
                fieldName,
                curSearch.replaceAll(
                  primarySearchColumn.searchMask!.from,
                  primarySearchColumn.searchMask!.to,
                ),
              );
            }
          }
        } else {
          // no search string provided, and no column user sorted. make sure to sort the primary search column if available.

          if (_columnSettings[searchableColumns.first].fieldName != null) {
            ListGridColumn curColumn = _columnSettings[searchableColumns.first];
            String fieldName = curColumn.fieldName!;
            outputQuery = outputQuery.orderBy(fieldName, descending: curColumn.descending);
          }
        }
      } else {
        Console.log(
          "fframeLog.ListGridNotifier: no searchable column specified",
          level: LogLevel.fframe,
        );
      }
    }

    // apply the newly computedQuery as the current query
    _currentQuery = outputQuery as Query<T>;
    Console.log(
      "fframeLog.ListGridNotifier: ${outputQuery.parameters.toString()}",
      level: LogLevel.fframe,
    );

    // the query has changed; recalculate the result collection count
    _updateCollectionCount(query: _currentQuery as Query<T>);

    // notify the listeners that a redraw is needed
    notifyListeners();
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
