import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/models/suggestion.dart';

class Tab01 extends StatelessWidget {
  const Tab01({
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

    // debugPrint("Loading suggestion: ${suggestion.name ?? 'new'}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(
        //   height: 100.0,
        //   width: double.infinity,
        //   child: Placeholder(
        //     color: Colors.indigo,
        //     child: Center(
        //       child: Text("Static header"),
        //     ),
        //   ),
        // ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: readOnly,
                  decoration: const InputDecoration(
                    // hoverColor: Color(0xFFFF00C8),
                    // hoverColor: Theme.of(context).indicatorColor,
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                  initialValue: suggestion.name ?? '',
                  validator: (curValue) {
                    if (validator.validString(curValue)) {
                      suggestion.name = curValue;
                      return null;
                    } else {
                      return 'Enter a valid name';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (String? value) {
                    suggestion.fieldTab1 = value;
                  },
                  readOnly: readOnly,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "tab1 value",
                  ),
                  initialValue: suggestion.fieldTab1 ?? '',
                  validator: (value) {
                    if (!validator.validString(value)) {
                      return 'Enter a valid value';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
