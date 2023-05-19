import 'package:example/models/suggestion.dart';
import 'package:example/themes/config.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/helpers/icons.dart';
import 'package:example/helpers/strings.dart';
import 'package:flutterfire_ui/auth.dart';

List<ListGridColumn<Suggestion>> listGridColumns = [
  ListGridColumn(
    fieldName: 'name',
    searchable: false,
    searchMask: const ListGridSearchMask(from: " ", to: "_", toLowerCase: true),
    sortable: true,
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 300,
    cellBuilder: (context, suggestion) {
      return SuggestionListItem(
        suggestion: suggestion,
        selected: true,
        user: FFrameUser(),
      );
    },
  ),
  ListGridColumn(
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 200,
    textAlign: TextAlign.center,
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
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 40,
    textAlign: TextAlign.center,
    cellBuilder: (context, suggestion) {
      return Tooltip(
        message: suggestion.active == true
            ? "Suggestion is active"
            : "Suggestion is inactive",
        child: Icon(
          suggestion.active == true ? Icons.toggle_on : Icons.toggle_off,
          color: suggestion.active == true
              ? SignalColors().constAccentColor
              : Theme.of(context).disabledColor,
        ),
      );
    },
  ),
  ListGridColumn(
    label: "created by",
    visible: true,
    fieldName: 'createdBy',
    sortable: true,
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 300,
    // textAlign: TextAlign.right,
    textSelectable: true,
    valueBuilder: (context, suggestion) {
      return "${suggestion.createdBy}";
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
  ),
  ListGridColumn(
    label: "tab 1",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 250,
    valueBuilder: (context, suggestion) {
      return "${suggestion.fieldTab1}";
    },
  ),
  ListGridColumn(
    label: "tab 2",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 80,
    generateTooltip: true,
    valueBuilder: (context, suggestion) {
      return "${suggestion.fieldTab2}";
    },
  ),
  ListGridColumn(
    label: "tab 3",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 200,
    valueBuilder: (context, suggestion) {
      return "${suggestion.fieldTab3}";
    },
    cellColor: Colors.pink,
  ),
  ListGridColumn(
    label: "creation date",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 1000,
    valueBuilder: (context, suggestion) {
      return dateTimeTextTS(suggestion.creationDate as Timestamp);
    },
  ),
  ListGridColumn(
    label: "saveCount",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 120,
    textAlign: TextAlign.end,
    valueBuilder: (context, suggestion) {
      return suggestion.saveCount;
    },
  ),
  ListGridColumn(
    fieldName: 'name',
    visible: false,
    searchable: true,
    // searchMask: const ListGridSearchMask(from: " ", to: "_", toLowerCase: true),
    valueBuilder: (context, suggestion) {
      return suggestion.name;
    },
  ),
];

renderButtons({required BuildContext context, required Suggestion suggestion}) {
  return Row(
    children: [
      Tooltip(
        message: 'Retry Run...',
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
        message: 'Kill Run...',
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
        message: 'Open run in new tab...',
        child: OutlinedButton.icon(
          icon: const Icon(
            Icons.open_in_browser,
            size: 16,
          ),
          label: const Text(""),
          onPressed: () {},
          // onPressed: () {
          //   FRouter.of(context).navigateToRouteFromNavigationTargets(
          //     FRouter.of(context).navigationConfig.navigationTargets,
          //     route: "runs/${run.cluster!['branch']}",
          //     id: run.id!,
          //   );
          // },
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
