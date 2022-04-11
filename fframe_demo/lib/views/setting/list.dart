import 'package:fframe_demo/models/setting.dart';
import 'package:flutter/material.dart';

import 'package:fframe_demo/helpers/icons.dart';

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
      selected: selected,
      title: Text(setting.name!,
          style: TextStyle(
              decoration:
                  selected ? TextDecoration.underline : TextDecoration.none)),
      leading: Icon(iconMap[setting.icon]),
    );
  }
}
