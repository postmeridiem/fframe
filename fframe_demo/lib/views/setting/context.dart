import 'package:fframe_demo/models/setting.dart';
import 'package:flutter/material.dart';

class ContextCard extends StatelessWidget {
  const ContextCard({Key? key, required this.setting}) : super(key: key);
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Column(children: [
            Text("Unnamed",
                style: TextStyle(
                  // fontFamily: mainFontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )),
            Divider(color: Theme.of(context).colorScheme.onBackground),
            Text(
              "injected widget goes here",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
