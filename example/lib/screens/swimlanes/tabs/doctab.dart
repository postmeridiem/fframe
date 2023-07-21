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

    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Placeholder(),
    );
  }
}
