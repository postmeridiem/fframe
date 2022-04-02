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
    List<String>? avatarText = user.displayName
        ?.split(' ')
        .map((part) => part.trim().substring(0, 1))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: const [Text("manage roles here")],
      ),
    );
  }
}
