import 'package:fframe/models/setting.dart';
import 'package:flutter/material.dart';

class settingList extends StatelessWidget {
  const settingList({
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
      title: Text(setting.name!),
      leading: Icon(
        IconData(
          // icon codes match with here https://api.flutter.dev/flutter/material/Icons-class.html#constants
          int.parse("0x${setting.icon}"),
          fontFamily: 'MaterialIcons',
        ),
      ),
    );
  }
}
