import 'package:flutter/material.dart';
import 'package:fframe_demo/models/user.dart';

class RolesTab extends StatelessWidget {
  const RolesTab({
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
            children: [
              Text("current roles: ${user.customClaims!['roles'] ?? ''}")
            ],
          ),
        ),
      ),
    );
  }
}
