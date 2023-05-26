import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:example/models/suggestion.dart';
import 'package:example/themes/config.dart';
import 'package:example/helpers/icons.dart';
import 'package:example/helpers/strings.dart';

List<ListGridColumn<Suggestion>> listGridColumns = [
  // ListGridColumn(
  //   fieldName: 'name',
  //   searchable: false,
  //   sortable: true,
  //   columnSizing: ListGridColumnSizingMode.fixed,
  //   columnWidth: 300,
  //   cellBuilder: (context, suggestion) {
  //     return SuggestionListItem(
  //       suggestion: suggestion,
  //       selected: true,
  //       user: FFrameUser(),
  //     );
  //   },
  // ),
  ListGridColumn(
    fieldName: 'name',
    searchable: true,
    sortable: true,
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 300,
    valueBuilder: (context, suggestion) {
      return suggestion.name;
    },
    cellControlsBuilder: (
      context,
      user,
      suggestion,
      stringValue,
    ) {
      return [
        IconButton(
          onPressed: () {
            FlutterClipboard.copy(stringValue);
          },
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
        ),
      ];
    },
  ),
  ListGridColumn(
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 40,
    cellBuilder: (context, suggestion) {
      return Tooltip(
        message: suggestion.active == true
            ? "Suggestion is active"
            : "Suggestion is inactive",
        child: Icon(
          suggestion.active == true
              ? Icons.toggle_on
              : Icons.toggle_off_outlined,
          color: suggestion.active == true
              ? SignalColors().constAccentColor
              : Theme.of(context).disabledColor,
        ),
      );
    },
  ),
  ListGridColumn(
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 200,
    cellBuilder: (context, suggestion) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          renderButtons(
            context: context,
            suggestion: suggestion,
          ),
        ],
      );
    },
  ),
  ListGridColumn(
    label: "created by",
    visible: true,
    fieldName: 'createdBy',
    // searchable: true,
    sortable: true,
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 300,
    alignment: Alignment.bottomRight,
    textSelectable: true,
    valueBuilder: (context, suggestion) {
      return suggestion.createdBy;
    },
    cellControlsBuilder: (
      context,
      user,
      suggestion,
      stringValue,
    ) {
      return renderCreatedByCellIcons(
        context: context,
        suggestion: suggestion,
        stringValue: stringValue,
      );
    },
  ),
  ListGridColumn(
    label: "",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 40,
    cellBuilder: (context, suggestion) {
      return FutureBuilder(
        future: Future.delayed(
          const Duration(
            seconds: 1,
          ),
        ),
        builder: (c, s) {
          switch (s.connectionState) {
            case ConnectionState.done:
              return Icon(
                Icons.check,
                color: SignalColors().constSuccessColor,
              );
            default:
              return LoadingIndicator(
                size: 10,
                borderWidth: 1,
                color: SignalColors().constRunningColor,
              );
          }
        },
      );
    },
    cellControlsBuilder: (
      context,
      user,
      suggestion,
      stringValue,
    ) {
      return [
        IconButton(
          onPressed: () {
            FlutterClipboard.copy(stringValue);
          },
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
        ),
      ];
    },
  ),
  ListGridColumn(
    label: "tab 1",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 250,
    generateTooltip: true,
    valueBuilder: (context, suggestion) {
      return suggestion.fieldTab1;
    },
    cellControlsBuilder: (
      context,
      user,
      suggestion,
      stringValue,
    ) {
      return [
        IconButton(
          onPressed: () {
            FlutterClipboard.copy(stringValue);
          },
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
        ),
      ];
    },
  ),
  ListGridColumn(
    label: "tab 2",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 80,
    valueBuilder: (context, suggestion) {
      return suggestion.fieldTab2;
    },
    cellControlsBuilder: (
      context,
      user,
      suggestion,
      stringValue,
    ) {
      return [
        IconButton(
          onPressed: () {
            FlutterClipboard.copy(stringValue);
          },
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
        ),
      ];
    },
  ),
  ListGridColumn(
    label: "tab 3",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 200,
    generateTooltip: true,
    valueBuilder: (context, suggestion) {
      return suggestion.fieldTab3;
    },
    cellColor: Colors.pink,
    cellControlsBuilder: (
      context,
      user,
      suggestion,
      stringValue,
    ) {
      return [
        IconButton(
          onPressed: () {
            FlutterClipboard.copy(stringValue);
          },
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
        ),
      ];
    },
  ),
  ListGridColumn(
    label: "creation date",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 1000,
    valueBuilder: (context, suggestion) {
      return dateTimeTextTS(suggestion.creationDate as Timestamp);
    },
    cellControlsBuilder: (
      context,
      user,
      suggestion,
      stringValue,
    ) {
      return [
        IconButton(
          onPressed: () {
            FlutterClipboard.copy(stringValue);
          },
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
        ),
      ];
    },
  ),
  ListGridColumn(
    label: "saveCount",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 120,
    alignment: Alignment.bottomRight,
    valueBuilder: (context, suggestion) {
      return suggestion.saveCount;
    },
    cellControlsBuilder: (
      context,
      user,
      suggestion,
      stringValue,
    ) {
      return [
        IconButton(
          onPressed: () {
            FlutterClipboard.copy(stringValue);
          },
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
        ),
      ];
    },
  ),
  // ListGridColumn(
  //   fieldName: 'name',
  //   visible: false,
  //   searchable: true,
  //   // searchMask: const ListGridSearchMask(from: " ", to: "_", toLowerCase: true),
  //   // valueBuilder: (context, suggestion) {
  //   //   return suggestion.name;
  //   // },
  // ),
];

Row renderButtons(
    {required BuildContext context, required Suggestion suggestion}) {
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

class SuggestionListItem extends StatelessWidget {
  const SuggestionListItem({
    required this.suggestion,
    required this.selected,
    required this.user,
    Key? key,
  }) : super(key: key);
  final Suggestion suggestion;
  final FFrameUser? user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      mouseCursor: SystemMouseCursors.click,
      selected: selected,
      title: Text(
        "${suggestion.name}",
        style: TextStyle(
          decoration: selected ? TextDecoration.underline : TextDecoration.none,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      selectedColor: Theme.of(context).colorScheme.onTertiary,
      selectedTileColor: Theme.of(context).colorScheme.tertiary,
      leading: Icon(iconMap[suggestion.icon]),
    );
  }
}
