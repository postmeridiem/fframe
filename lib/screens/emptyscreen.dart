import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee,
              color: Colors.grey,
              size: 24.0,
            ),
            // SelectableText("No content to show"),
          ],
        ),
      );
}
