import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class DocTab extends StatelessWidget {
  const DocTab({
    Key? key,
    required this.swimlanesTask,
    required this.readOnly,
  }) : super(key: key);
  final SwimlanesTask swimlanesTask;
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
              initialValue: swimlanesTask.createdBy ?? "unknown",
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
              initialValue: swimlanesTask.name ?? '',
              validator: (curValue) {
                if (validator.validString(curValue)) {
                  swimlanesTask.name = curValue;
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
                swimlanesTask.status = value ?? "";
              },
              readOnly: readOnly,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "tab1 value",
              ),
              initialValue: swimlanesTask.status ?? '',
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
    );
  }
}
