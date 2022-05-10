import 'package:fframe/fframe.dart';
import 'package:example/models/suggestion.dart';
import 'package:flutter/material.dart';

class Tab03 extends StatelessWidget {
  const Tab03({
    Key? key,
    required this.suggestion,
  }) : super(key: key);
  final Suggestion suggestion;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "tab3 value",
        ),
        initialValue: suggestion.fieldTab2 ?? '',
        validator: (value) {
          if (!Validator().validString(value)) {
            return 'Enter a valid value';
          }
          suggestion.fieldTab3 = value;
          return null;
        },
      ),
    );
  }
}
