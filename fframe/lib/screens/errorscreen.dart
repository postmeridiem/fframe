import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fframe/helpers/l10n.dart';

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
                    child: Text(
                      L10n.string(
                        'errors_homelink',
                        placeholder: "Home",
                      ),
                    ),
                  )
                : const IgnorePointer(),
            externalLocation != null
                ? TextButton(
                    onPressed: () =>
                        launchUrl(Uri.dataFromString(externalLocation!)),
                    child: Text(
                      L10n.string(
                        "errors_externalreference",
                        placeholder: "Launch external reference",
                      ),
                    ),
                  )
                : const IgnorePointer(),
          ],
        ),
      );
}
