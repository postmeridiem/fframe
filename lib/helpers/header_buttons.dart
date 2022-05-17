import 'package:fframe/fframe.dart';
import 'package:fframe/screens/mainscreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fframe/providers/global_providers.dart';
import 'package:fframe/controllers/selection_state_controller.dart';

import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class BarButtonShare extends ConsumerWidget {
  const BarButtonShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SelectionState selectionState = ref.watch(selectionStateProvider).state;
    Map<String, String>? queryParams = selectionState.queryParams;
    String? queryString;
    if (queryParams != null) {
      queryString =
          "/?${queryParams.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    return IconButton(
      onPressed: () {
        String url =
            "${Uri.base.replace(query: null).toString()}${queryString ?? ""}";
        FlutterClipboard.copy(url).then((_) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Copied current location ($url) to clipboard."),
              behavior: SnackBarBehavior.floating));
        });
      },
      icon: const Icon(Icons.share),
      tooltip: "Copy the current location to the paste buffer...",
    );
  }
}

class BarButtonDuplicate extends ConsumerWidget {
  const BarButtonDuplicate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SelectionState selectionState = ref.watch(selectionStateProvider).state;
    Map<String, String>? queryParams = selectionState.queryParams;
    String? queryString;
    if (queryParams != null) {
      queryString =
          "/?${queryParams.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    return IconButton(
      onPressed: () {
        String url =
            "${Uri.base.replace(query: null).toString()}${queryString ?? ""}";
        launch(url).then((_) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Opened current location ($url) in new tab."),
              behavior: SnackBarBehavior.floating));
        });
      },
      icon: const Icon(Icons.open_in_new),
      tooltip: "Open the current page in a new tab...",
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
            launch(issuePageLink!).then((_) {
              return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Opened GitHub issue tracker in a new tab."),
                  behavior: SnackBarBehavior.floating));
            });
          },
          icon: const Icon(Icons.pest_control),
          tooltip: 'translationkey',
        );
      },
    );
  }
}

class BarButtonProfile extends StatelessWidget {
  const BarButtonProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const IconButton(
      onPressed: _signOut,
      icon: Icon(Icons.logout_outlined),
      tooltip: "Log out...",
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}