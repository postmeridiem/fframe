import 'package:fframe/models/runConfig.dart';
import 'package:flutter/material.dart';

class RunConfigList extends StatelessWidget {
  const RunConfigList({
    required this.runConfig,
    required this.selected,
    Key? key,
  }) : super(key: key);
  final RunConfig runConfig;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: Text(runConfig.name!),
      leading: runConfig.active!
          ? Icon(
              Icons.model_training,
              color: Colors.green,
            )
          : Icon(
              Icons.pending_outlined,
              color: Colors.grey,
            ),
    );
  }
}
