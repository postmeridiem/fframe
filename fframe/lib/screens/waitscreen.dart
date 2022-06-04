import 'package:flutter/material.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({Key? key, this.color}) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: color,
        ),
      );
}
