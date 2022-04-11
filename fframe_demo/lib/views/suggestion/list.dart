import 'package:fframe_demo/models/suggestion.dart';
import 'package:flutter/material.dart';

import 'package:fframe_demo/helpers/icons.dart';

class SuggestionListItem extends StatelessWidget {
  const SuggestionListItem({
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
      title: Text(suggestion.name!,
          style: TextStyle(
              decoration:
                  selected ? TextDecoration.underline : TextDecoration.none)),
      leading: Icon(iconMap[suggestion.icon]),
      trailing: Icon(iconMap[suggestion.icon]),
    );
  }
}
