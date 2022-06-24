import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/l10n.dart';
import 'package:flutter/material.dart';

class InitializeL10n extends StatelessWidget {
  const InitializeL10n({
    Key? key,
    required this.l10Builder,
    required this.navigationConfig,
    required this.l10nConfig,
  }) : super(key: key);
  final NavigationConfig navigationConfig;
  final L10Builder l10Builder;
  // final Widget child;
  final L10nConfig l10nConfig;

  @override
  Widget build(BuildContext context) {
    debugPrint("Initialize l10n");
    return FutureBuilder(
      future: L10nReader.read(context, l10nConfig),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        // debugPrint("l10n ConnectionState $ConnectionState");
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return l10Builder(
              context,
              null,
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              Map<String, dynamic> _localeData = snapshot.data as Map<String, dynamic>;
              // create the language engine
              debugPrint("L10N: Language engine loaded.");
              return l10Builder(
                context,
                L10n(
                  l10nConfig: l10nConfig,
                  localeData: _localeData,
                ),
              );
            } else {
              // create the language engine
              debugPrint("L10N ERROR: Language engine failed to load.");
              return l10Builder(
                context,
                L10n(
                  l10nConfig: l10nConfig,
                  localeData: {},
                ),
              );
            }
          // return l10Builder(context,l10n);
        }
      },
    );
  }
}

typedef L10Builder = Widget Function(
  BuildContext context,
  L10n? l10n,
);
