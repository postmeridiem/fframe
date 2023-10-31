import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/models/suggestion.dart';

class DocTab extends StatelessWidget {
  const DocTab({
    Key? key,
    required this.suggestion,
    required this.readOnly,
  }) : super(key: key);
  final Suggestion suggestion;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    // register shared validator class for common patterns
    Validator validator = Validator();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              readOnly: true,
              initialValue: suggestion.createdBy ?? "unknown",
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Author",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              readOnly: readOnly,
              decoration: const InputDecoration(
                // hoverColor: Color(0xFFFF00C8),
                // hoverColor: Theme.of(context).indicatorColor,
                border: OutlineInputBorder(),
                labelText: "Name",
              ),
              initialValue: suggestion.name ?? '',
              validator: (newValue) {
                if (validator.validString(newValue)) {
                  suggestion.name = newValue;
                  return null;
                } else {
                  return 'Enter a valid name';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              // onSaved: (String? value) {
              //   suggestion.fieldTab1 = value;
              // },
              readOnly: readOnly,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "tab1 value",
              ),
              initialValue: suggestion.fieldTab1 ?? '',
              validator: (newValue) {
                if (validator.validString(newValue)) {
                  suggestion.fieldTab1 = newValue;
                  return null;
                } else {
                  return 'Enter a valid value';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              // onSaved: (String? value) {
              //   suggestion.fieldTab1 = value;
              // },
              readOnly: readOnly,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "tab2 value",
              ),
              initialValue: suggestion.fieldTab2 ?? '',
              validator: (newValue) {
                if (validator.validString(newValue)) {
                  suggestion.fieldTab2 = newValue;
                  return null;
                } else {
                  return 'Enter a valid value';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              // onSaved: (String? value) {
              //   suggestion.fieldTab1 = value;
              // },
              readOnly: readOnly,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "tab3 value",
              ),
              initialValue: suggestion.fieldTab3 ?? '',
              validator: (newValue) {
                if (validator.validString(newValue)) {
                  suggestion.fieldTab3 = newValue;
                  return null;
                } else {
                  return 'Enter a valid value';
                }
              },
            ),
          ),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler"),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("filler to test scroll behavior..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
          const Text("..."),
        ],
      ),
    );
  }
}
