import 'package:flutter/material.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({Key? key, this.color}) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: color,
        ),
      );
}
