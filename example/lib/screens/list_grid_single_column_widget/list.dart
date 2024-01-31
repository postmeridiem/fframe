import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/models/suggestion.dart';
import 'package:example/helpers/strings.dart';

List<ListGridColumn<Suggestion>> listGridColumns = [
  ListGridColumn(
    alignment: Alignment.bottomLeft,
    columnSizing: ListGridColumnSizingMode.flex,
    cellBuilder: (context, suggestion, saveDocument) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          renderButtons(
            context: context,
            suggestion: suggestion!,
          ),
        ],
      );
    },
  ),
];

Row renderButtons({required BuildContext context, required Suggestion suggestion}) {
  return Row(
    children: [
      Tooltip(
        message: 'Retry...',
        child: OutlinedButton.icon(
          icon: const Icon(
            Icons.send_outlined,
            size: 16,
          ),
          label: const Text(""),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
      ),
      Tooltip(
        message: 'Stop...',
        child: OutlinedButton.icon(
          icon: const Icon(
            Icons.front_hand,
            size: 16,
          ),
          label: const Text(""),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
      ),
      Tooltip(
        message: 'Open in new tab...',
        child: OutlinedButton.icon(
          icon: const Icon(
            Icons.open_in_browser,
            size: 16,
          ),
          label: const Text(""),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
      ),
    ],
  );
}

List<IconButton> renderCreatedByCellIcons({
  required BuildContext context,
  required Suggestion suggestion,
  required String stringValue,
}) {
  return [
    IconButton(
      onPressed: () {
        FlutterClipboard.copy(stringValue);
      },
      icon: const Icon(Icons.copy),
      tooltip: 'Copy',
    ),
    IconButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ListTile(
              leading: const Icon(
                Icons.date_range,
              ),
              title: Text(
                dateTimeTextTS(suggestion.creationDate as Timestamp),
              ),
              textColor: Colors.amber[900],
            ),
          ),
        );
      },
      icon: const Icon(Icons.date_range),
      tooltip: 'Show creation date',
    ),
    IconButton(
      onPressed: () {
        suggestion.active = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ListTile(
              leading: Icon(
                Icons.alarm,
                color: Colors.amber[900],
              ),
              title: Text(stringValue),
              textColor: Colors.amber[900],
            ),
          ),
        );
      },
      icon: const Icon(Icons.alarm_add),
      tooltip: 'Show value in snackbar',
    ),
  ];
}
