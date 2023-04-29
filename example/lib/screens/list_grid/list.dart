import 'package:example/models/suggestion.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/helpers/icons.dart';

List<ListGridColumn<Suggestion>> listGridColumns = [
  ListGridColumn(
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
    label: "created by",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 300,
    valueBuilder: (context, suggestion) {
      return "${suggestion.createdBy}";
    },
  ),
  ListGridColumn(
    label: "tab 1",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 100,
    valueBuilder: (context, suggestion) {
      return "${suggestion.fieldTab1}";
    },
  ),
  ListGridColumn(
    label: "tab 2",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 120,
    valueBuilder: (context, suggestion) {
      return "${suggestion.fieldTab2}";
    },
  ),
  ListGridColumn(
    label: "tab 1",
    columnSizing: ListGridColumnSizingMode.fixed,
    columnWidth: 120,
    valueBuilder: (context, suggestion) {
      return "${suggestion.fieldTab3}";
    },
    cellColor: Colors.pink,
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
