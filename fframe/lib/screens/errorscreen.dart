import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.error,
    this.initiallLocation,
    this.externalLocation,
    Key? key,
  }) : super(key: key);
  final Exception error;
  final String? initiallLocation;
  final String? externalLocation;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_rounded,
              color: Colors.yellowAccent,
              size: 48.0,
            ),
            SelectableText(error.toString()),
            initiallLocation != null
                ? TextButton(
                    onPressed: () => context.go(initiallLocation!),
                    child: const Text('Home'),
                  )
                : const IgnorePointer(),
            externalLocation != null
                ? TextButton(
                    onPressed: () => launch(externalLocation!),
                    child: const Text('Launch external reference'),
                  )
                : const IgnorePointer(),
          ],
        ),
      );
}
