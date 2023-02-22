import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/console_logger.dart';
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
    Console.log("Initialize L10n",
        scope: "fframeLog.L10n", level: LogLevel.fframe);
    return FutureBuilder(
      future: L10nReader.read(context, l10nConfig),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
              Map<String, dynamic> localeData =
                  snapshot.data as Map<String, dynamic>;
              // create the language engine
              Console.log("Language engine loaded",
                  scope: "fframeLog.L10n", level: LogLevel.fframe);
              return l10Builder(
                context,
                L10n(
                  l10nConfig: l10nConfig,
                  localeData: localeData,
                ),
              );
            } else {
              // create the language engine
              Console.log("ERROR: Language engine failed to load.",
                  scope: "fframeLog.L10n", level: LogLevel.fframe);
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
