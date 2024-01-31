import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/models/suggestion.dart';

class Tab01 extends StatefulWidget {
  const Tab01({
    Key? key,
    required this.suggestion,
    required this.readOnly,
  }) : super(key: key);
  final Suggestion suggestion;
  final bool readOnly;

  @override
  State<Tab01> createState() => _Tab01State();
}

class _Tab01State extends State<Tab01> {
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
              initialValue: widget.suggestion.createdBy ?? "unknown",
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Author",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              readOnly: widget.readOnly,
              decoration: const InputDecoration(
                // hoverColor: Color(0xFFFF00C8),
                // hoverColor: Theme.of(context).indicatorColor,
                border: OutlineInputBorder(),
                labelText: "Name",
              ),
              initialValue: widget.suggestion.name ?? '',
              validator: (curValue) {
                if (validator.validString(curValue)) {
                  widget.suggestion.name = curValue;
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
              onSaved: (String? value) {
                widget.suggestion.fieldTab1 = value;
              },
              readOnly: widget.readOnly,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "tab1 value",
              ),
              initialValue: widget.suggestion.fieldTab1 ?? '',
              validator: (value) {
                if (!validator.validString(value)) {
                  return 'Enter a valid value';
                }
                return null;
              },
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.suggestion.name = "${widget.suggestion.name}.";
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}
