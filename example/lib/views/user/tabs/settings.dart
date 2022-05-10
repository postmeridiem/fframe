import 'package:flutter/material.dart';
import 'package:example/models/user.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    required this.user,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: const [
              Text("change stuff like permanent dark mode"),
            ],
          ),
        ),
      ),
    );
  }
}
