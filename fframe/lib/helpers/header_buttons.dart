import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fframe/providers/global_providers.dart';
import 'package:fframe/controllers/selection_state_controller.dart';

import 'package:fframe/helpers/l10n.dart';

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
    SelectionState selectionState = ref.watch(selectionStateProvider).state;
    Map<String, String>? queryParams = selectionState.queryParams;
    String? queryString;
    if (queryParams != null) {
      queryString =
          "/?${queryParams.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    return IconButton(
      onPressed: () {
        String _url =
            "${Uri.base.replace(query: null).toString()}${queryString ?? ""}";
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
              return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Opened issue tracker in a new tab."),
                  behavior: SnackBarBehavior.floating));
            });
          },
          icon: const Icon(Icons.pest_control),
          tooltip: "Open issue tracker...",
        );
      },
    );
  }
}

class BarButtonProfile extends StatelessWidget {
  const BarButtonProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String? _photoUrl = FirebaseAuth.instance.currentUser!.photoURL;
    print(_photoUrl);
    String _profileName =
        FirebaseAuth.instance.currentUser!.displayName as String;
    List<String>? _avatarText = _profileName
        .split(' ')
        .map((part) => part.trim().substring(0, 1))
        .toList();
    CircleAvatar? _circleAvatar = CircleAvatar(
      radius: 16.0,
      child: (_photoUrl == null)
          ? Text(
              "${_avatarText.first}${_avatarText.last}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          : null,
      backgroundImage: (_photoUrl == null) ? null : NetworkImage(_photoUrl),
      backgroundColor: (_photoUrl == null) ? Colors.amber : Colors.white,
    );

    return PopupMenuButton(
      color: Theme.of(context).colorScheme.tertiary,
      offset: Offset.fromDirection(100.0),
      icon: _circleAvatar,
      onSelected: (item) => _onSelected(context, item),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "profile",
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              mouseCursor: SystemMouseCursors.click,
              leading: _circleAvatar,
              title: Text(
                _profileName,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              subtitle: Text(
                L10n.string("header_profilelabel",
                    placeholder: "Click to open profile...",
                    namespace: "fframe"),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 12),
              ),
            ),
          ),
        ),
        // PopupMenuDivider(),
        const PopupMenuItem<String>(
          child: ThemeDropdown(),
        ),
        const PopupMenuItem<String>(
          child: LocaleDropdown(),
        ),
        // PopupMenuDivider(),
        PopupMenuItem<String>(
          value: "logout",
          child: ListTile(
            leading: Icon(Icons.logout_outlined,
                color: Theme.of(context).colorScheme.onTertiary),
            title: Text(
              L10n.string("header_signout",
                  placeholder: "Sign out...", namespace: "fframe"),
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
        ),
      ],
    );
  }

  void _onSelected(BuildContext context, item) {
    switch (item) {
      case 'logout':
        _signOut();
        break;
      case 'profile':
        debugPrint('Open profile');
        break;
      case 'void':
        break;
      default:
        break;
    }
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class ThemeDropdown extends StatefulWidget {
  const ThemeDropdown({Key? key}) : super(key: key);

  @override
  State<ThemeDropdown> createState() => _ThemeDropdownState();
}

class _ThemeDropdownState extends State<ThemeDropdown> {
  String dropdownValue = 'Theme: auto';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).colorScheme.tertiary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            elevation: 16,
            underline: Container(
              height: 2,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['Theme: auto', 'Theme: light', 'Theme: dark']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class LocaleDropdown extends StatefulWidget {
  const LocaleDropdown({Key? key}) : super(key: key);

  @override
  State<LocaleDropdown> createState() => _LocaleDropdownState();
}

class _LocaleDropdownState extends State<LocaleDropdown> {
  String dropdownValue = 'Locale: en-US';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).colorScheme.tertiary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            elevation: 16,
            underline: Container(
              height: 2,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['Locale: en-US', 'Locale: nl-NL']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
