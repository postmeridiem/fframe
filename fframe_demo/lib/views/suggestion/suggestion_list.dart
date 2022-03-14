import 'package:fframe_demo/models/suggestion.dart';
import 'package:flutter/material.dart';

class SuggestionList extends StatelessWidget {
  const SuggestionList({
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
      leading: Icon(
        IconData(
          // icon codes match with here https://api.flutter.dev/flutter/material/Icons-class.html#constants
          int.parse("0x${suggestion.icon}"),
          fontFamily: 'MaterialIcons',
        ),
      ),
    );
  }
}
