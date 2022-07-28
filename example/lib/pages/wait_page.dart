import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    String? waitText = Fframe.of(context)?.waitText;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: color,
        ),
        if (waitText != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                waitText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
