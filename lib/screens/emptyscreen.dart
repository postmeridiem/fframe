import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 128.0,
            ),
            // SelectableText("No content to show"),
          ],
        ),
      );
}
