import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

// ignore: must_be_immutable
class AdvancedDataTable<T> extends StatefulWidget {

  AdvancedDataTable({
    Key? key,
    required this.headerWidgets,
    required this.footerWidgets,
    required this.columnWidths,
    required this.cellsForRowAtIndex,
    this.headerSticky = false,
    // this.firstColumnSticky = false,
    this.data
  }):
        assert(headerWidgets.length == columnWidths.length, 'colum widths should match number of columns'),
        super(key: key);

  final List<double> columnWidths;

  final List<Widget> headerWidgets;
  final List<Widget> footerWidgets;
  final bool headerSticky;
  // final bool firstColumnSticky;

  List<T>? data;
  CellsForRowAtIndex<int, T> cellsForRowAtIndex;

  @override
  State<AdvancedDataTable> createState() => _AdvancedDataTableState();
}

class _AdvancedDataTableState extends State<AdvancedDataTable> {

  @override
  Widget build(BuildContext context) {

    List<Widget> leftHandSideRows = [];

    leftHandSideRows.addAll(widget.data!.asMap().entries.map((row) {
      List<Widget> cells = widget.cellsForRowAtIndex(row.key, row.value).sublist(0 , 1);
      return Row(
        children: widget.columnWidths.sublist(0,1).asMap().entries.map((width) => SizedBox(width: width.value, child: cells[width.key])).toList(),
      );
    } ).toList());

    List<Widget> rightHandSideRows = [];

    rightHandSideRows.addAll(widget.data!.asMap().entries.map((row) {
      List<Widget> cells = widget.cellsForRowAtIndex(row.key, row.value).sublist(1);
      return Row(
        children: widget.columnWidths.sublist(1).asMap().entries.map((width) => SizedBox(width: width.value, child: cells[width.key])).toList(),
      );
    } ).toList());

    return HorizontalDataTable(
      leftHandSideColumnWidth: widget.columnWidths[0],
      rightHandSideColumnWidth: widget.columnWidths.sublist(1).reduce((value, element) => value + element),
      isFixedHeader: true,
      headerWidgets: widget.columnWidths.asMap().entries.map((width) => SizedBox(width: width.value, child: widget.headerWidgets[width.key])).toList(),
      isFixedFooter: true,
      footerWidgets: widget.footerWidgets,
      leftSideItemBuilder: (BuildContext leftContext, int index) {
        return leftHandSideRows[index];
      },
      rightSideItemBuilder: (BuildContext rightContext, int index) {
        return rightHandSideRows[index];
      },
      itemCount: widget.data != null ? widget.data!.length : 0,
      rowSeparatorWidget: const Divider(
        color: Colors.black38,
        height: 1.0,
        thickness: 0.0,
      ),
      leftHandSideColBackgroundColor: Theme.of(context).colorScheme.onPrimary,
      rightHandSideColBackgroundColor: Theme.of(context).colorScheme.onPrimary,
    );

  }

}

typedef CellsForRowAtIndex<int, T> = List<Widget> Function(
    int index,
    T rowData
);