import 'package:fframe/models/suggestion.dart';
import 'package:flutter/material.dart';

class suggestionList extends StatelessWidget {
  const suggestionList({
    required this.suggestion,
    required this.selected,
    Key? key,
  }) : super(key: key);
  final Suggestion suggestion;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: Text(suggestion.name!),
      leading: Icon(iconMap[suggestion.icon]),
    );
  }
}

Map<String, IconData> iconMap = {
  'add_shopping_cart': Icons.add_shopping_cart,
  'calendar_view_week_rounded': Icons.calendar_view_day_rounded,
  'call_end_outlined': Icons.call_end_outlined,
  'call_made': Icons.call_made,
  'home_work': Icons.home_work,
  'chevron_left': Icons.chevron_left,
  'chevron_right': Icons.chevron_right,
  'fullscreen_exit': Icons.fullscreen_exit,
  'fullscreen': Icons.fullscreen,
  'menu_open': Icons.menu_open,
  'switch_left': Icons.switch_left,
  'switch_right': Icons.switch_right,
  'apps': Icons.apps,
  'apps_outage': Icons.apps_outage,
};