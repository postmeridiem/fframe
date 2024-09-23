// ignore_for_file: unnecessary_import

import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class BarButtonShare extends StatelessWidget {
  const BarButtonShare({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        String url = "${Uri.base}";
        FlutterClipboard.copy(url).then((_) {
          if (context.mounted) {
            return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  L10n.string(
                    "header_copydeeplink_message",
                    placeholder: "Copied current location to clipboard.",
                    namespace: 'fframe',
                  ),
                ),
                behavior: SnackBarBehavior.floating));
          }
        });
      },
      icon: const Icon(Icons.share),
      tooltip: L10n.string(
        'header_copydeeplink',
        placeholder: 'Copy deeplink...',
        namespace: 'fframe',
      ),
    );
  }
}

class BarButtonDuplicate extends StatelessWidget {
  const BarButtonDuplicate({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        launchUrl(Uri.base).then((_) {
          if (context.mounted) {
            return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  L10n.string(
                    "header_opennewtab_message",
                    placeholder: "Duplicated current page in new tab.",
                    namespace: 'fframe',
                  ),
                ),
                behavior: SnackBarBehavior.floating));
          }
        });
      },
      icon: const Icon(Icons.open_in_new),
      tooltip: L10n.string(
        'header_opennewtab',
        placeholder: 'Open in new tab...',
        namespace: 'fframe',
      ),
    );
  }
}

class BarButtonFeedback extends StatelessWidget {
  const BarButtonFeedback({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        launchUrl(Uri.https("github.com", "postmeridiem/fframe/issues")).then((_) {
          if (context.mounted) {
            return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opened issue tracker in a new tab."), behavior: SnackBarBehavior.floating));
          }
        });
      },
      icon: const Icon(Icons.pest_control),
      tooltip: "Open issue tracker...",
    );
  }
}
