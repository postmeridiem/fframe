import 'package:fframe/models/user.dart';
import 'package:flutter/material.dart';

// TODO: add the active inactive filter back in
class UserList extends StatelessWidget {
  const UserList({
    required this.user,
    required this.selected,
    Key? key,
  }) : super(key: key);
  final User user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
//      leading: Icon(Icons.person),
      title: Text(user.name!),
    );
  }
}
