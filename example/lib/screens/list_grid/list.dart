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
  //   cellBuilder: (BuildContext context, Suggestion suggestion) {
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
    valueBuilder: (BuildContext context, Suggestion suggestion) {
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
    columnWidth: 60,
    cellBuilder:
        (BuildContext context, Suggestion suggestion, Function saveDocument) {
      return Switch(
        value: (suggestion.active ?? false),
        onChanged: (bool value) {
          suggestion.active = value;
          saveDocument();
        },
      );
    },
  ),
  ListGridColumn(
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 200,
    cellBuilder:
        (BuildContext context, Suggestion suggestion, Function saveDocument) {
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
    valueBuilder: (BuildContext context, Suggestion suggestion) {
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
    cellBuilder:
        (BuildContext context, Suggestion suggestion, Function saveDocument) {
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
      BuildContext context,
      FFrameUser? user,
      suggestion,
      String stringValue,
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
    valueBuilder: (BuildContext context, Suggestion suggestion) {
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
    valueBuilder: (BuildContext context, Suggestion suggestion) {
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
    valueBuilder: (BuildContext context, Suggestion suggestion) {
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
    valueBuilder: (BuildContext context, Suggestion suggestion) {
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
    valueBuilder: (BuildContext context, Suggestion suggestion) {
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
];

class SuggestionActiveToggle extends StatelessWidget {
  const SuggestionActiveToggle({
    Key? key,
    required this.suggestion,
  }) : super(key: key);

  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: suggestion.active == true
          ? "Suggestion is active"
          : "Suggestion is inactive",
      // child: Icon(
      //   suggestion.active == true ? Icons.toggle_on : Icons.toggle_off_outlined,
      //   color: suggestion.active == true
      //       ? SignalColors().constAccentColor
      //       : Theme.of(context).disabledColor,
      // ),
      child: Switch(
        value: (suggestion.active ?? false),
        onChanged: (bool value) {
          suggestion.active = value;
          // save();
          // DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
        },
      ),
    );
  }
}

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
