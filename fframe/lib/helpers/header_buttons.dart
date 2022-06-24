import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fframe/helpers/l10n.dart';

import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class BarButtonShare extends ConsumerWidget {
  const BarButtonShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        String url = "${Uri.base}";
        FlutterClipboard.copy(url).then((_) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                L10n.string(
                  "header_copydeeplink_message",
                  placeholder: "Copied current location to clipboard.",
                  namespace: 'fframe',
                ),
              ),
              behavior: SnackBarBehavior.floating));
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

class BarButtonDuplicate extends ConsumerWidget {
  const BarButtonDuplicate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        String _url = "${Uri.base}";
        launchUrl(Uri.dataFromString(_url)).then((_) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // content: Text("Opened current location ($_url) in new tab."),
              content: Text(
                L10n.string(
                  "header_opennewtab_message",
                  placeholder: "Duplicated current page in new tab.",
                  namespace: 'fframe',
                ),
              ),
              behavior: SnackBarBehavior.floating));
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
    Key? key,
    this.issuePageLink,
  }) : super(key: key);
  final String? issuePageLink;
  @override
  Widget build(BuildContext context) {
    if (issuePageLink == null) return const IgnorePointer();
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: () {
            launchUrl(Uri.dataFromString(issuePageLink!)).then((_) {
              return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opened issue tracker in a new tab."), behavior: SnackBarBehavior.floating));
            });
          },
          icon: const Icon(Icons.pest_control),
          tooltip: "Open issue tracker...",
        );
      },
    );
  }
}

