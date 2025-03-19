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
          Console.log("fframeLog.ListGridNotifier: searching for: $searchString");
          if (searchableColumns.length > 1) {
            //TODO JPM: make multiple columns supported
            Console.log("fframeLog.ListGridNotifier: ERROR: Multiple searchable columns not supported at this time. Please adjust configuration");
            // List<Filter> currentFilters = [];
            // for (int searchableColumnIndex in searchableColumns) {
            //   String curSearch = searchString!;
            //   ListGridColumn curColumn = _columnSettings[searchableColumnIndex];
            //   if (curColumn.fieldName != null) {
            //     String fieldName = curColumn.fieldName!;
            //     outputQuery = outputQuery.orderBy(fieldName,
            //         descending: curColumn.descending);
            //     if (curColumn.searchMask != null) {
            //       if (curColumn.searchMask!.toLowerCase) {
            //         curSearch = curSearch.toLowerCase();
            //       }
            //       curSearch = curSearch.replaceAll(
            //         curColumn.searchMask!.from,
            //         curColumn.searchMask!.to,
            //       );
            //     }
            //     currentFilters.add(Filter(fieldName, isEqualTo: curSearch));
            //     outputQuery = outputQuery.startsWith(
            //       fieldName,
            //       curSearch,
            //     );
            //   }
            //   outputQuery = outputQuery
            //       .where(Filter.or(currentFilters[0], currentFilters[1]));
            // }
          } else {
            if (_columnSettings[searchableColumns.first].fieldName != null) {
              String curSearch = searchString!;
              ListGridColumn curColumn = _columnSettings[searchableColumns.first];
              String fieldName = curColumn.fieldName!;
              outputQuery = outputQuery.orderBy(fieldName, descending: curColumn.descending);
              if (curColumn.searchMask == null) {
                outputQuery = outputQuery.startsWith(fieldName, curSearch);
              } else {
                if (curColumn.searchMask!.toLowerCase) {
                  curSearch = curSearch.toLowerCase();
                }
                outputQuery = outputQuery.startsWith(
                  fieldName,
                  curSearch.replaceAll(
                    curColumn.searchMask!.from,
                    curColumn.searchMask!.to,
                  ),
                );
              }
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
