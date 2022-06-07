import 'package:example/models/setting.dart';
import 'package:flutter/material.dart';

import 'package:example/helpers/icons.dart';

class SettingListItem extends StatelessWidget {
  const SettingListItem({
    required this.setting,
    required this.selected,
    Key? key,
  }) : super(key: key);
  final Setting setting;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      mouseCursor: SystemMouseCursors.click,
      selected: selected,
      title: Text(
        setting.name!,
        style: TextStyle(
          decoration: selected ? TextDecoration.underline : TextDecoration.none,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      selectedColor: Theme.of(context).colorScheme.onTertiary,
      selectedTileColor: Theme.of(context).colorScheme.tertiary,
      leading: Icon(iconMap[setting.icon]),
    );
  }
}
