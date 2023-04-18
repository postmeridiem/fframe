import 'package:flutter/material.dart';
import 'list_grid_data.dart';

import 'package:example/models/appuser.dart';

class ListGridScreen extends StatefulWidget {
  const ListGridScreen({Key? key}) : super(key: key);

  @override
  State<ListGridScreen> createState() => _ListGridScreenState();
}

class _ListGridScreenState extends State<ListGridScreen> {
  bool isAscending = false;

  TUser user = TUser();

  @override
  Widget build(BuildContext context) {
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
                        child: ListGrid(),
                      ),
                      SizedBox(
                        width: 500,
                        height: null,
                        child: ListGrid(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListGrid(),
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

class ListGrid extends StatefulWidget {
  const ListGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<ListGrid> createState() => _ListGridState();
}

class _ListGridState extends State<ListGrid> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: SingleChildScrollView(
              child: Table(
                columnWidths: {
                  0: FixedColumnWidth(100),
                  1: FixedColumnWidth(100),
                  2: FlexColumnWidth(),
                  3: FixedColumnWidth(100),
                },
                defaultColumnWidth: FlexColumnWidth(),
                textDirection: TextDirection.ltr,
                border: TableBorder.all(),
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                  renderRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow renderRow() {
    return TableRow(
      // decoration: getRowDecorations(),
      children: [
        renderCell(),
        renderCell(),
        renderCell(),
        renderCell(),
      ],
    );
  }

  Placeholder renderCell() {
    return Placeholder(
      child: Container(
        color: Colors.blueGrey,
        child: Text("text"),
      ),
    );
  }

  BoxDecoration getRowDecorations() {
    return BoxDecoration(
      color: const Color(0xff7c94b6),
      image: const DecorationImage(
        image: NetworkImage(
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
        fit: BoxFit.cover,
      ),
      border: Border.all(
        width: 8,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
