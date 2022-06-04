import 'package:example/navigation_config.dart';
import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("FRouter Example"),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              NavigationNotifier navigationNotifier = ref.watch(navigationProvider);
              if (navigationNotifier.isSignedIn) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    navigationNotifier.isSignedIn = false;
                  },
                );
              }
              return const IgnorePointer();
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Consumer(
                builder: (context, ref, child) {
                  // NavigationNotifier navigationNotifier = ref.read(navigationProvider);
                  return Column(
                    children: [
                      Text("Last build: ${DateFormat('HH:mm:ss').format(DateTime.now())}"),
                      ...navigationConfig.navigationTargets
                          .map(
                            (NavigationTarget navigationTarget) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      FRouter.of(context).navigateTo(navigationTarget: navigationTarget);
                                    },
                                    icon: navigationTarget.destination!.icon,
                                    label: navigationTarget.destination!.label,
                                  ),
                                  ...?navigationTarget.navigationTabs
                                      ?.map((NavigationTab navigationTab) => Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  FRouter.of(context).navigateTo(navigationTarget: navigationTab);
                                                },
                                                child: Text(navigationTab.title)),
                                          ))
                                      .toList()
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      Consumer(
                        builder: (context, ref, child) {
                          NavigationNotifier navigationNotifier = ref.watch(navigationProvider);
                          if (!navigationNotifier.isSignedIn) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    navigationNotifier.uri = Uri.parse("/${navigationConfig.signInConfig.signInTarget.path}".replaceAll("//", "/"));
                                  },
                                  icon: navigationConfig.signInConfig.signInTarget.destination!.icon,
                                  label: Text(navigationConfig.signInConfig.signInTarget.title)),
                            );
                          }
                          return const IgnorePointer();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const VerticalDivider(
              color: Colors.blueGrey,
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Consumer(
                builder: (context, ref, child) {
                  TargetState targetState = ref.watch(targetStateProvider);
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      key: ValueKey("navTarget_${targetState.navigationTarget.title}"),
                      child: targetState.navigationTarget.contentPane,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
