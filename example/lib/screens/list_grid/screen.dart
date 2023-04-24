import 'package:flutter/material.dart';
import 'package:example/screens/list_grid/components/list_grid.dart';
import 'package:example/screens/list_grid/components/mock_data.dart';

class ListGridScreen extends StatefulWidget {
  const ListGridScreen({Key? key}) : super(key: key);

  @override
  State<ListGridScreen> createState() => _ListGridScreenState();
}

class _ListGridScreenState extends State<ListGridScreen> {
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    Map<int, ListGridColumn> columnSettings = {
      0: ListGridColumn(
        key: "name",
        header: "Name",
        columnSizing: ListGridColumnSizingMode.fixed,
        columnWidth: 250,
      ),
      1: ListGridColumn(
          key: "channel",
          header: "CH",
          columnSizing: ListGridColumnSizingMode.fixed,
          columnWidth: 50,
          textAlign: TextAlign.center),
      2: ListGridColumn(
        key: "nickname",
        header: "Nickname",
        columnSizing: ListGridColumnSizingMode.flex,
      ),
      // 2: ListGridColumn(
      //   key: "nickname",
      //   header: "Nickname",
      //   columnSizing: ListGridColumnSizingMode.fixed,
      //   columnWidth: 200,
      //   textAlign: TextAlign.end,
      // ),
      3: ListGridColumn(
        key: "numerical",
        header: "#",
        columnSizing: ListGridColumnSizingMode.fixed,
        columnWidth: 100,
        cellBuilder: (BuildContext context, celldata) {
          return Text(
            "$celldata",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          );
        },
      ),
    };
    return ListGrid(
      data: mockData,
      columnSettings: columnSettings,
      cellBorder: 1,
    );
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: null,
                  height: 400,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListGrid(
                          data: mockData,
                          columnSettings: columnSettings,
                          cellPadding: const EdgeInsets.all(4.0),
                          cellBackgroundColor: Colors.blueGrey,
                          widgetBackgroundColor: Colors.deepPurple,
                          widgetTextStyle: const TextStyle(color: Colors.white),
                          headerHeight: 28,
                          footerHeight: 28,
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        height: null,
                        child: ListGrid(
                          data: mockData,
                          columnSettings: columnSettings,
                          footerHeight: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListGrid(
                          data: mockData,
                          columnSettings: columnSettings,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
