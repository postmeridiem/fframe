import 'dart:async';
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
    // initialize the sorting object. Seeded from a column marked `sortedColumn` below, so a
    // grid can open already sorted; null means no sort, which falls back to ordering by the
    // first searchable column (see _queryBuilder).
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

      // open sorted by this column, if one asks for it. The ListGridColumn constructor
      // asserts sortedColumn implies sortable and a non-null fieldName, which _queryBuilder
      // needs; the assert below rejects more than one.
      if (columnSetting.sortedColumn && sortedColumnIndex == null) {
        sortedColumnIndex = i;
      }
    }

    assert(
      _columnSettings.where((column) => column.sortedColumn).length <= 1,
      'Only one column may set `sortedColumn`: the grid can open sorted by a single column.',
    );

    assert(
      _listGridConfig!.searchAsContains || searchableColumns.length <= 1,
      'Multiple searchable columns are only supported when `searchAsContains` is true. Please enable `searchAsContains` in ListGridConfig or mark only one column as searchable.',
    );

    if (_listGridConfig!.searchAsContains) {
      // When 'searchAsContains' is enabled, all documents are fetched upfront
      // to support client-side "contains" filtering. This is necessary because
      // Firestore does not support native "contains" queries.
      _prefetchDocuments(_initialQuery as Query<T>);
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

  /// A cache of all documents for the initial query.
  ///
  /// This is populated when `searchAsContains` is true, allowing for
  /// client-side filtering across the entire dataset without repeated
  /// database queries. It is null if `searchAsContains` is false.
  List<QueryDocumentSnapshot<T>>? _prefetchedDocs;

  /// Getter for the cached documents.
  List<QueryDocumentSnapshot<T>>? get prefetchedDocs => _prefetchedDocs;
  Timer? _debounce;

  /// The maximum number of documents fetched for client-side "contains" search.
  /// Bounds cost and memory so a large collection is never fully materialized.
  static const int _prefetchDocumentLimit = 2000;

  /// Set when the prefetch query fails, so the UI can render an error state
  /// instead of an indefinite loading spinner.
  Object? _prefetchError;
  Object? get prefetchError => _prefetchError;

  /// True once this notifier is disposed; guards async callbacks that may
  /// complete after teardown.
  bool _disposed = false;

  String? get searchString {
    return _searchString;
  }

  /// Sets the search string for filtering the list.
  ///
  /// To prevent performance issues with rapid typing, this setter uses a
  /// debouncing mechanism. It waits for a 300ms pause in user input
  /// before triggering the `_queryBuilder` to re-filter the data. This ensures
  /// that the filtering logic doesn't run on every keystroke, providing a
  /// smoother user experience, especially with large datasets.
  set searchString(String? searchString) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (searchString != null && searchString.isNotEmpty) {
        _searchString = searchString;
      } else {
        _searchString = null;
      }
      _queryBuilder();
    });
  }

  void _queryBuilder() {
    // A rebuilt query changes which rows are visible, so a prior selection may
    // now reference off-screen documents that can no longer be deselected. Clear
    // it to keep the selection count and bulk actions in sync with the results.
    if (_selectedDocuments.isNotEmpty) {
      _selectedDocuments.clear();
    }

    Query outputQuery = _initialQuery as Query<T>;

    // Search decides the ordering when both are active: Firestore requires the field carrying
    // a range filter to be the first field ordered, so `startsWith` can only be applied to a
    // field this query orders by. Ordering by the sorted column instead put the filter on the
    // wrong field, which returned nothing. A user's sort is therefore ignored while searching.
    final bool isSearching = searchString != null && searchString!.isNotEmpty;

    if (isSearching && searchableColumns.isNotEmpty) {

      // For server-side searches (`startsWith`), Firestore requires the query to be
      // ordered by the same field used in the range filter. We use the first
      // available searchable column as the primary one for this purpose.
      // The assertion in the constructor ensures that for server-side searches,
      // there is only one searchable column configured.
      final ListGridColumn primarySearchColumn = _columnSettings[searchableColumns.first];

      if (primarySearchColumn.fieldName != null) {
        String curSearch = searchString!;
        String fieldName = primarySearchColumn.fieldName!;
        // Never log the search term itself — it is user input and can carry customer names or
        // email addresses. The field being filtered is the useful part for debugging.
        Console.log(
          "fframeLog.ListGridNotifier: search active, filtering and ordering on $fieldName",
          level: LogLevel.fframe,
        );
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
    } else if (sortedColumnIndex != null) {
      // A column is sorted and nothing is being searched: order by it, no range filter.
      ListGridColumn sortedColumn = _columnSettings[sortedColumnIndex!];
      Console.log(
        "fframeLog.ListGridNotifier: column sorted on ${sortedColumn.fieldName!}",
        level: LogLevel.fframe,
      );

      outputQuery = outputQuery.orderBy(sortedColumn.fieldName!, descending: sortedColumn.descending);
    } else if (searchableColumns.isNotEmpty) {
      // Neither searching nor sorted: order by the primary searchable column so the grid
      // still has a stable, predictable order.
      if (_columnSettings[searchableColumns.first].fieldName != null) {
        ListGridColumn curColumn = _columnSettings[searchableColumns.first];
        String fieldName = curColumn.fieldName!;
        outputQuery = outputQuery.orderBy(fieldName, descending: curColumn.descending);
      }
    } else {
      Console.log(
        "fframeLog.ListGridNotifier: no searchable column specified",
        level: LogLevel.fframe,
      );
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
    if (_disposed) return;
    int collectionCount = snapshot.count!;
    _collectionCount = collectionCount;
  }

  /// Fetches all documents from the given [query] and stores them in
  /// [_prefetchedDocs].
  ///
  /// This method is called when `searchAsContains` is true to load the entire
  /// dataset into memory for client-side searching. It notifies listeners
  /// upon completion or if an error occurs.
  Future<void> _prefetchDocuments(Query<T> query) async {
    try {
      // Bound the read so an unbounded collection is never fully loaded into
      // memory (cost/OOM). Client-side "contains" search covers the capped set.
      final snapshot = await query.limit(_prefetchDocumentLimit).get();
      if (_disposed) return;
      _prefetchedDocs = snapshot.docs;
      _prefetchError = null;
      if (snapshot.docs.length >= _prefetchDocumentLimit) {
        Console.log(
          "fframeLog.ListGridNotifier: prefetch hit the $_prefetchDocumentLimit-document cap; client-side search may be incomplete. Disable searchAsContains for large collections.",
          level: LogLevel.prod,
        );
      }
      Console.log("Pre-fetched ${_prefetchedDocs?.length ?? 0} documents for client-side search.", scope: "fframeLog.ListGridNotifier", level: LogLevel.fframe);
    } catch (e) {
      if (_disposed) return;
      // Record the error so the builder can surface it instead of spinning
      // forever on a null prefetch result.
      _prefetchError = e;
      Console.log("Error pre-fetching documents: $e", level: LogLevel.prod);
    }
    notifyListeners(); // Notify that prefetched data is available or an error occurred.
  }

  void update() {
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
