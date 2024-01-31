part of '../../fframe.dart';

class ListGridConfig<T> {
  ListGridConfig({
    required this.columnSettings,
    this.dataMode = const ListGridDataModeConfig(mode: ListGridDataMode.all),
    this.widgetBackgroundColor,
    this.widgetColor,
    this.widgetAccentColor,
    this.widgetTextColor,
    this.widgetTextSize = 16,
    this.rowBorder = 1,
    this.cellBorder = 0,
    this.cellPadding = const EdgeInsets.all(8.0),
    this.cellVerticalAlignment = TableCellVerticalAlignment.middle,
    this.cellBackgroundColor,
    this.defaultTextStyle,
    this.showHeader = true,
    this.showFooter = true,
    this.rowsSelectable = false,
    this.hideListOnDocumentOpen = false,
    this.openDocumentOnClick = true,
    this.searchHint,
    this.actionBar = const [],
  });

  final List<ListGridColumn<T>> columnSettings;
  final ListGridDataModeConfig dataMode;

  final Color? widgetBackgroundColor;
  final Color? widgetColor;
  final Color? widgetAccentColor;
  final Color? widgetTextColor;
  final double widgetTextSize;

  final double rowBorder;
  final double cellBorder;
  final EdgeInsetsGeometry cellPadding;
  final TableCellVerticalAlignment cellVerticalAlignment;
  final Color? cellBackgroundColor;
  final TextStyle? defaultTextStyle;

  final bool showHeader;
  final bool showFooter;
  final bool rowsSelectable;
  final bool hideListOnDocumentOpen;
  final bool openDocumentOnClick;
  final String? searchHint;
  final List<ListGridActionMenu<T>> actionBar;
}

class ListGridActionMenu<T> {
  const ListGridActionMenu({
    required this.menuItems,
    this.label,
    this.icon,
  });

  final List<ListGridActionMenuItem<T>> menuItems;
  final String? label;
  final IconData? icon;
}

class ListGridActionMenuItem<T> {
  const ListGridActionMenuItem({
    required this.label,
    required this.icon,
    this.processSelection = true,
    required this.onClick,
  });

  final String label;
  final IconData icon;
  final bool processSelection;
  final ListGridActionHandler<T> onClick;
}

typedef ListGridActionHandler<T> = SelectedDocument<T>? Function(
  BuildContext context,
  FFrameUser? user,
  SelectedDocument<T>? selectedDocument,
  DocumentScreenConfig? screenConfig,
);

class ListGridColumn<T> {
  ListGridColumn({
    this.label = '',
    this.visible = true,
    this.fieldName,
    this.searchable = false,
    this.searchMask,
    this.sortable = false,
    this.descending = false,
    this.valueBuilder,
    this.cellBuilder,
    this.columnSizing = ListGridColumnSizingMode.flex,
    this.columnWidth = 200,
    this.alignment = Alignment.bottomLeft,
    this.cellColor,
    this.textSelectable = false,
    this.generateTooltip = false,
    this.cellControlsBuilder,
    this.onTableCellClick,
    // this.dynamicTextStyle,
    // this.dynamicBackgroundColor,
  });

  String label;
  bool visible;
  String? fieldName;
  bool searchable;
  ListGridSearchMask? searchMask;
  bool sortable;
  bool descending;
  ListGridColumnSizingMode columnSizing;
  double columnWidth;
  Alignment alignment;

  Color? cellColor;

  ListGridValueBuilderFunction<T>? valueBuilder;
  ListGridCellBuilderFunction<T>? cellBuilder;
  ListGridCellControlsBuilderFunction<T>? cellControlsBuilder;

  // List<IconButton>? cellControls;

  bool textSelectable;
  bool generateTooltip;

  late int? columnIndex;
  late bool sortedColumn = false;

  OnTableCellClick<T>? onTableCellClick;
}

typedef OnTableCellClick<T> = void Function(
  BuildContext context,
  SelectedDocument<T> document,
);

class ListGridDataModeConfig {
  const ListGridDataModeConfig({
    this.mode = ListGridDataMode.limit,
    this.limit = 100,
    // this.autopagerRowHeight,
  });

  final ListGridDataMode mode;
  final int limit;
// final double? autopagerRowHeight;
}

class ListGridSearchConfig<T> {
  const ListGridSearchConfig({
    required this.mode,
    this.field,
    this.multiFields,
  });

  final ListGridSearchMode mode;
  final String? field;
  final List<String>? multiFields;
}

class ListGridSearchMask {
  const ListGridSearchMask({
    required this.from,
    required this.to,
    this.toLowerCase = false,
  });

  final String from;
  final String to;
  final bool toLowerCase;
}

class SelectedDocument<T> {
  final DocumentConfig<T> documentConfig;
  final DocumentSnapshot<Map<String, dynamic>>? documentSnapshot;
  final DocumentReference<T>? documentReference;

  String? _id;
  T? _data;

  SelectedDocument({
    required id,
    required this.documentConfig,
    this.documentSnapshot,
    this.documentReference,
    T? data,
  }) {
    _id = id;
    if (data != null) {
      _data = data;
    } else if (this.documentSnapshot != null) {
      _data = documentConfig.fromFirestore(this.documentSnapshot!, null);
    }
  }

  // Getter for _data
  T? get data => _data;

  String? get id => _id;

  // Setter for _data
  set data(T? newData) {
    if (newData != null) {
      documentConfig.toFirestore(newData, null);
      _data = newData;
    }
  }

  close({required BuildContext context}) {
    DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    documentScreenConfig.close(context: context);
  }

  open({required BuildContext context}) {
    DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    documentScreenConfig.selectDocument(context, this);
  }

  update({T? newData}) {
    T data = newData ?? _data!;
    if (_id == null) {
      //Must be a new document, create an Id for it
      _id = documentConfig.createDocumentId!(data);
      DatabaseService<T>().createDocument(
        collection: documentConfig.collection,
        documentId: _id!,
        data: data,
        fromFirestore: documentConfig.fromFirestore,
        toFirestore: documentConfig.toFirestore,
      );
    } else {
      DatabaseService<T>().updateDocument(
        collection: documentConfig.collection,
        documentId: _id!,
        data: data,
        fromFirestore: documentConfig.fromFirestore,
        toFirestore: documentConfig.toFirestore,
      );
    }
  }

  factory SelectedDocument.createNew({required BuildContext context}) {
    DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig = documentScreenConfig.documentConfig as DocumentConfig<T>;
    return SelectedDocument<T>(
      documentConfig: documentConfig,
      id: null,
      data: documentScreenConfig.create<T>(context: context) as T,
    );
  }
}

enum ListGridColumnSizingMode {
  flex,
  fixed,
}

enum ListGridDataMode {
  all,
  autopager,
  lazy,
  limit,
  pager,
}

enum ListGridSearchMode {
  singleFieldString,
  multiFieldString,
  underscoreTypeAhead,
}

typedef ListGridValueBuilderFunction<T> = Function(
  BuildContext context,
  T data,
);

typedef ListGridCellBuilderFunction<T> = Widget Function(
  BuildContext context,
  T? data,
  Function? onChange,
);

typedef ListGridCellControlsBuilderFunction<T> = List<IconButton> Function(
  BuildContext context,
  FFrameUser? user,
  SelectedDocument<T>? data,
  String stringValue,
);
