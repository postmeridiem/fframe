import 'package:fframe_demo/models/home.dart';
import 'package:flutter/material.dart';

// TODO: add the active inactive filter back in
class HomeList extends StatelessWidget {
  const HomeList({
    required this.home,
    required this.selected,
    Key? key,
  }) : super(key: key);
  final Home home;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
//      leading: Icon(Icons.person),
      title: Text(home.name!),
    );
  }
}
