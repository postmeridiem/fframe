part of fframe;

class FirestoreDataGrid<T> extends StatefulWidget {
  const FirestoreDataGrid({
    Key? key,
    required this.query,
    // required this.fireStoreQueryState,
    required this.dataGridConfig,
    this.header,
    this.onError,
    this.canDeleteItems = false,
    this.actions,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.dataRowHeight,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.showFirstLastButtons = false,
    this.onPageChanged,
    this.rowsPerPage = 10,
    this.dragStartBehavior = DragStartBehavior.start,
    this.arrowHeadColor,
    this.checkboxHorizontalMargin,
  }) :

        ///assert(columnLabels is LinkedHashMap,'only LinkedHashMap are supported as header' ), // using an assert instead of a type because `<A, B>{}` types as `Map` but is an instance of `LinkedHashMap`
        super(key: key);

  final DataGridConfig<T> dataGridConfig;

  /// The firestore query that will be displayed
  final Query<T> query;
  // final Query<T> Function(Query<T> query)? query;
  // final FireStoreQueryState<T> fireStoreQueryState;

  /// Whether documents can be removed from firestore using the table.
  final bool canDeleteItems;

  /// The columns and their labels based on the property name in Firestore
  //final Map<String, Widget> columnLabels;
  /// The configuration and labels for the columns in the table.
  // final List<DataColumn> columnLabels;
  // final List<DataCell> Function(T data) dataCells;

  /// When specified, will be called whenever an interaction with Firestore failed,
  /// when as when trying to delete an item without the proper rights.
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// The table card's optional header.
  ///
  /// This is typically a [Text] widget, but can also be a [Row] of
  /// [TextButton]s. To show icon buttons at the top end side of the table with
  /// a header, set the [actions] property.
  ///
  /// If items in the table are selectable, then, when the selection is not
  /// empty, the header is replaced by a count of the selected items. The
  /// [actions] are still visible when items are selected.
  final Widget? header;

  /// Icon buttons to show at the top end side of the table. The [header] must
  /// not be null to show the actions.
  ///
  /// Typically, the exact actions included in this list will vary based on
  /// whether any rows are selected or not.
  ///
  /// These should be size 24.0 with default padding (8.0).
  final List<Widget>? actions;

  /// Invoked when the user switches to another page.
  ///
  /// The value is the index of the first row on the currently displayed page.
  final void Function(int page)? onPageChanged;

  /// The height of each row (excluding the row that contains column headings).
  ///
  /// This value is optional and defaults to kMinInteractiveDimension if not
  /// specified.
  final double? dataRowHeight;

  /// The current primary sort key's column.
  ///
  /// See [DataTable.sortColumnIndex].
  final int? sortColumnIndex;

  /// Whether the column mentioned in [sortColumnIndex], if any, is sorted
  /// in ascending order.
  ///
  /// See [DataTable.sortAscending].
  final bool sortAscending;

  /// The height of the heading row.
  ///
  /// This value is optional and defaults to 56.0 if not specified.
  final double headingRowHeight;

  /// The horizontal margin between the edges of the table and the content
  /// in the first and last cells of each row.
  ///
  /// When a checkbox is displayed, it is also the margin between the checkbox
  /// the content in the first data column.
  ///
  /// This value defaults to 24.0 to adhere to the Material Design specifications.
  ///
  /// If [checkboxHorizontalMargin] is null, then [horizontalMargin] is also the
  /// margin between the edge of the table and the checkbox, as well as the
  /// margin between the checkbox and the content in the first data column.
  final double horizontalMargin;

  /// The horizontal margin between the contents of each data column.
  ///
  /// This value defaults to 56.0 to adhere to the Material Design specifications.
  final double columnSpacing;

  /// {@macro flutter.material.dataTable.showCheckboxColumn}
  final bool showCheckboxColumn;

  /// Flag to display the pagination buttons to go to the first and last pages.

  final bool showFirstLastButtons;

  /// The number of rows to show on each page.
  ///
  /// Defaults to 10
  final int rowsPerPage;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// Defines the color of the arrow heads in the footer.
  final Color? arrowHeadColor;

  /// Horizontal margin around the checkbox, if it is displayed.
  ///
  /// If null, then [horizontalMargin] is used as the margin between the edge
  /// of the table and the checkbox, as well as the margin between the checkbox
  /// and the content in the first data column. This value defaults to 24.0.

  final double? checkboxHorizontalMargin;
  @override
  FirestoreDataGridState createState() => FirestoreDataGridState<T>();
}

class FirestoreDataGridState<T> extends State<FirestoreDataGrid<T>> {
  late Query<T> _query;

  bool get selectionEnabled => widget.canDeleteItems;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
  }

  @override
  void didUpdateWidget(covariant FirestoreDataGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query.hashCode != oldWidget.query.hashCode) {
      _query = widget.query;
      // _query = _unwrapQuery(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    FFrameDataTableSource<T> fFrameDataTableSource = FFrameDataTableSource<T>(
      documentScreenConfig: DocumentScreenConfig.of(context)!,
      getOnError: () => widget.onError,
      selectionEnabled: selectionEnabled,
      rowsPerPage: widget.rowsPerPage,
      dataGridConfig: widget.dataGridConfig,
    );
    return FirestoreQueryBuilder<T>(
      query: _query,
      builder: (context, snapshot, child) {
        fFrameDataTableSource.fromSnapShot(snapshot);

        return AnimatedBuilder(
          animation: fFrameDataTableSource,
          builder: (context, child) {
            final actions = [
              ...?widget.actions,
              if (widget.canDeleteItems &&
                  fFrameDataTableSource._selectedRowIds.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: fFrameDataTableSource.onDeleteSelectedItems,
                ),
            ];
            return LayoutBuilder(builder: (context, constraints) {
              double headingRowHeight = widget.headingRowHeight;
              double? dataRowHeight = widget.dataRowHeight;

              int rowsPerPage = widget.rowsPerPage;
              return PaginatedDataTableExtended(
                source: fFrameDataTableSource,
                onSelectAll:
                    selectionEnabled ? fFrameDataTableSource.onSelectAll : null,
                onPageChanged: widget.onPageChanged,
                showCheckboxColumn: widget.showCheckboxColumn,
                arrowHeadColor: widget.arrowHeadColor,
                checkboxHorizontalMargin: widget.checkboxHorizontalMargin,
                columnSpacing: widget.columnSpacing,
                dataRowHeight: dataRowHeight,
                dragStartBehavior: widget.dragStartBehavior,
                headingRowHeight: headingRowHeight,
                horizontalMargin: widget.horizontalMargin,
                rowsPerPage: rowsPerPage,
                showFirstLastButtons: widget.showFirstLastButtons,
                sortAscending: widget.sortAscending,
                sortColumnIndex: widget.sortColumnIndex,
                header: actions.isEmpty
                    ? null
                    : (widget.header ?? const SizedBox()),
                actions: actions.isEmpty ? null : actions,
                // Head label
                columns: widget.dataGridConfig.dataGridConfigColumns
                    .map((DataGridConfigColumn<T> dataGridConfigColumn) =>
                        dataGridConfigColumn.headerBuilder())
                    .toList(),
              );
            });
          },
        );
      },
    );
  }
}

class FframeDataRow<T> extends DataRow {
  const FframeDataRow({
    key,
    selected = false,
    onSelectChanged,
    onLongPress,
    this.onTap,
    color,
    required List<DataCell> cells,
  }) : super(
          key: key,
          selected: selected,
          onSelectChanged: onSelectChanged,
          onLongPress: onLongPress,
          color: color,
          cells: cells,
        );

  final GestureLongPressCallback? onTap;
}

class FFrameDataTableSource<T> extends DataTableSource {
  FFrameDataTableSource({
    required this.documentScreenConfig,
    required this.dataGridConfig,
    required this.getOnError,
    required bool selectionEnabled,
    required int rowsPerPage,
  })  : _selectionEnabled = selectionEnabled,
        _rowsPerpage = rowsPerPage;
  final DocumentScreenConfig documentScreenConfig;
  final DataGridConfig<T> dataGridConfig;

  int _rowsPerpage;
  int get rowsPerPage => _rowsPerpage;
  set rowsPerPage(int value) {
    if (value != _rowsPerpage) {
      _rowsPerpage = value;
      notifyListeners();
    }
  }

  bool _selectionEnabled;
  bool get selectionEnabled => _selectionEnabled;
  set selectionEnabled(bool value) {
    if (value != _selectionEnabled) {
      _selectionEnabled = value;
      notifyListeners();
    }
  }

  //final Map<String, Widget> Function() getHeaders;
  final void Function(Object error, StackTrace stackTrace)? Function()
      getOnError;

  final _selectedRowIds = <String>{};

  @override
  int get selectedRowCount => _selectedRowIds.length;

  @override
  bool get isRowCountApproximate =>
      _previousSnapshot!.isFetching || _previousSnapshot!.hasMore;

  @override
  int get rowCount {
    // Emitting an extra item during load or before reaching the end
    // allows the DataTable to show a spinner during load & let the user
    // navigate to next page

    if (_previousSnapshot!.isFetching || _previousSnapshot!.hasMore) {
      return _previousSnapshot!.docs.length + rowsPerPage;
    }

    return _previousSnapshot!.docs.length;
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _previousSnapshot!.docs.length) {
      _previousSnapshot!.fetchMore();
    }
    if (index >= _previousSnapshot!.docs.length) return null;

    final QueryDocumentSnapshot<T> documentSnapshot =
        _previousSnapshot!.docs[index];
    final T data = documentSnapshot.data();

    return DataRow(
      selected: _selectedRowIds.contains(documentSnapshot.id),
      onSelectChanged: selectionEnabled
          ? (selected) {
              if (selected == null) return;

              if ((selected && _selectedRowIds.add(documentSnapshot.id)) ||
                  (!selected && _selectedRowIds.remove(documentSnapshot.id))) {
                notifyListeners();
              }
            }
          : null,
      cells: dataGridConfig.dataGridConfigColumns
          .map(
            (DataGridConfigColumn<T> dataGridConfigColumn) =>
                dataGridConfigColumn.dataCellBuilder(
              data,
              () {
                return DatabaseService<T>().updateDocument(
                  collection: documentSnapshot.reference.parent.path,
                  documentId: documentSnapshot.id,
                  data: data,
                  fromFirestore: dataGridConfig.fromFirestore,
                  toFirestore: dataGridConfig.toFirestore,
                );
              },
            ),
          )
          .toList(),
    );
  }

  FirestoreQueryBuilderSnapshot<T>? _previousSnapshot;

  void fromSnapShot(FirestoreQueryBuilderSnapshot<T>? snapshot) {
    if (snapshot == _previousSnapshot) return;

    // Try to preserve the selection status when the snapshot got updated,
    // such as when more content got loaded.
    final wereAllItemsSelected =
        _previousSnapshot?.docs.length == _selectedRowIds.length &&
            _previousSnapshot!.docs.isNotEmpty;

    _previousSnapshot = snapshot;
    if (wereAllItemsSelected) onSelectAll(true);
    notifyListeners();
  }

  void onSelectAll(bool? selected) {
    if (selected == null) return;

    if (selected) {
      _selectedRowIds.addAll(_previousSnapshot!.docs.map((e) => e.id));
    } else {
      _selectedRowIds.clear();
    }
    notifyListeners();
  }

  void onDeleteSelectedItems() {
    for (final doc in _previousSnapshot!.docs) {
      if (_selectedRowIds.contains(doc.id)) {
        doc.reference.delete().then<void>(
              (value) => _selectedRowIds.remove(doc.id),
              onError: getOnError(),
            );
      }
    }
  }
}

class DataGridConfig<T> {
  final List<DataGridConfigColumn<T>> dataGridConfigColumns;
  final bool showLinks;
  late T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
      fromFirestore;
  late Map<String, Object?> Function(T, SetOptions?) toFirestore;
  final int rowsPerPage;
  final double? rowHeight;

  DataGridConfig(
      {required this.dataGridConfigColumns,
      this.showLinks = true,
      this.rowsPerPage = -1,
      this.rowHeight});
}

class DataGridConfigColumn<T> {
  final DataGridConfigColumnSortOptions dataGridConfigColumnSortOptions;
  final DataColumn Function() headerBuilder;
  final DataCellBuilder<T> dataCellBuilder;

  DataGridConfigColumn({
    this.dataGridConfigColumnSortOptions = DataGridConfigColumnSortOptions.none,
    required this.headerBuilder,
    required this.dataCellBuilder,
  });
}

enum DataGridConfigColumnSortOptions {
  descending,
  ascending,
  none,
}

typedef DataCellBuilder<T> = DataCell Function(
  T data,
  Function save,
);
