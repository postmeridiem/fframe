import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';
import 'package:intl/intl.dart';


class DocumentBody extends StatefulWidget {
  const DocumentBody({
    Key? key,
    required this.queryState,
  }) : super(key: key);
  final QueryState queryState;

  @override
  State<DocumentBody> createState() => _DocumentBodyState();
}

class _DocumentBodyState extends State<DocumentBody> {
  @override
  Widget build(BuildContext context) {
    debugPrint("Build documentBody");
    return Column(
      key: ValueKey(widget.queryState.queryString),
      children: [
        const Text("Path"),
        Text("Last build: ${DateFormat('HH:mm:ss').format(DateTime.now())}"),
        Text(widget.queryState.queryString),
        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'What do people call you?',
            labelText: 'Name *',
          ),
          restorationId: "NameField",
        ),
      ],
    );
  }
}
