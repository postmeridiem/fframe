import 'package:example/models/fframe_page.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/helpers/icons.dart';

class PageListItem extends StatelessWidget {
  const PageListItem({
    required this.page,
    required this.selected,
    required this.user,
    Key? key,
  }) : super(key: key);
  final FframePage page;
  final FFrameUser? user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      mouseCursor: SystemMouseCursors.click,
      selected: selected,
      title: Text(
        "${page.name}",
        style: TextStyle(
          decoration: selected ? TextDecoration.underline : TextDecoration.none,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      selectedColor: Theme.of(context).colorScheme.onTertiary,
      selectedTileColor: Theme.of(context).colorScheme.tertiary,
      leading: Icon(iconMap[page.icon]),
    );
  }
}
