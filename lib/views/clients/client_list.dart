import 'package:fframe/models/client.dart';
import 'package:flutter/material.dart';

class clientList extends StatelessWidget {
  const clientList({
    required this.client,
    required this.selected,
    Key? key,
  }) : super(key: key);
  final Client client;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: Text(client.name!),
      // leading: client.active!
      //     ? Icon(
      //         Icons.check,
      //         color: Colors.greenAccent,
      //       )
      //     : Icon(
      //         Icons.disabled_by_default_outlined,
      //         color: Colors.redAccent,
      //       ),
    );
  }
}
