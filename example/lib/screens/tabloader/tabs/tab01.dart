import 'package:fframe/helpers/console_logger.dart';
import 'package:flutter/material.dart';

import 'package:example/models/fframe_page.dart';

class Tab01 extends StatelessWidget {
  const Tab01({
    Key? key,
    required this.page,
    required this.readOnly,
  }) : super(key: key);
  final FframePage page;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    Console.log("RENDERING TAB 1");
    return Placeholder(
      child: Center(
        child: FutureBuilder(
          future: Future.delayed(
            const Duration(
              seconds: 3,
            ),
          ),
          builder: (c, s) {
            switch (s.connectionState) {
              case ConnectionState.done:
                Console.log("Tab 1 loaded",
                    scope: "exampleApp.tabloader", level: LogLevel.dev);
                return const Text("Loaded");
              default:
                return const Text("Loading...");
            }
          },
        ),
      ),
    );
  }
}
