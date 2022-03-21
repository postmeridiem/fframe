import 'package:flutter/material.dart';

class Tab02 extends StatelessWidget {
  const Tab02({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: SizedBox(
        child: Placeholder(fallbackHeight: 2000),
      ),
    );
  }
}
