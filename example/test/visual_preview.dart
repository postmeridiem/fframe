// Visual companion to landing_page_resolution_test.dart.
//
// Run with: flutter run -d chrome test/visual_preview.dart
//
// Pick a persona on the left (and optionally a deep link); the harness runs
// the example app's real navigation config through Fframe's router
// initialisation and renders exactly what that end user would see in the
// content pane. Framework fallback pages (no landing page, no access) and the
// example error page render for real; pages that need Firebase data are shown
// as a routing summary instead.

import 'package:example/themes/themes.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/services/navigation_service.dart';
import 'package:flutter/material.dart';

import 'example_router_harness.dart';

void main() {
  Console(logThreshold: LogLevel.fframe);
  runApp(const VisualPreviewApp());
}

class Scenario {
  const Scenario({
    required this.label,
    required this.description,
    required this.roles,
    this.signedIn = true,
    this.deepLink,
  });

  final String label;
  final String description;
  final List<String> roles;
  final bool signedIn;

  /// When null, the scenario resolves the default (landing page) route.
  final String? deepLink;
}

const List<Scenario> scenarios = [
  Scenario(
    label: "Sign in as role: user",
    description: "Landing page is accessible, but all of its tabs are filtered away. Previously this user got the error page; now they land on /suggestions itself.",
    roles: ["user"],
  ),
  Scenario(
    label: "Sign in as role: developer",
    description: "Landing page and its first tab are accessible: lands on /suggestions/active.",
    roles: ["developer"],
  ),
  Scenario(
    label: "Sign in as role: useradmin",
    description: "Can access /users and others, but no landing page. Previously a blank/grey screen; now the 'No landing page configured' message.",
    roles: ["useradmin"],
  ),
  Scenario(
    label: "Sign in without any roles",
    description: "No accessible pages at all: the 'No landing page configured' message.",
    roles: [],
  ),
  Scenario(
    label: "Visit while signed out",
    description: "Default route for an anonymous visitor: the sign-in page.",
    roles: [],
    signedIn: false,
  ),
  Scenario(
    label: "useradmin opens /suggestions",
    description: "Deep link to a page that exists but is role-restricted. Previously a blank/grey screen; now the 'No access' message.",
    roles: ["useradmin"],
    deepLink: "/suggestions",
  ),
  Scenario(
    label: "useradmin opens /does-not-exist",
    description: "Deep link to an unknown URL: the example app's own error page.",
    roles: ["useradmin"],
    deepLink: "/does-not-exist",
  ),
  Scenario(
    label: "useradmin opens /users",
    description: "Deep link to a page the user does have access to: routes normally.",
    roles: ["useradmin"],
    deepLink: "/users",
  ),
];

class VisualPreviewApp extends StatelessWidget {
  const VisualPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Landing page resolution preview",
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const PreviewHome(),
    );
  }
}

class PreviewHome extends StatefulWidget {
  const PreviewHome({super.key});

  @override
  State<PreviewHome> createState() => _PreviewHomeState();
}

class _PreviewHomeState extends State<PreviewHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Scenario scenario = scenarios[selectedIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("Landing page resolution — end user preview")),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 320,
            child: ListView.builder(
              itemCount: scenarios.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  selected: index == selectedIndex,
                  title: Text(scenarios[index].label),
                  subtitle: scenarios[index].deepLink == null ? null : Text("deep link: ${scenarios[index].deepLink}"),
                  onTap: () => setState(() => selectedIndex = index),
                );
              },
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: ScenarioView(scenario: scenario)),
        ],
      ),
    );
  }
}

class ScenarioView extends StatelessWidget {
  const ScenarioView({super.key, required this.scenario});

  final Scenario scenario;

  @override
  Widget build(BuildContext context) {
    final FFrameUser? user = scenario.signedIn
        ? FFrameUser(
            uid: "preview",
            email: "preview@example.com",
            roles: scenario.roles,
          )
        : null;
    initRouterFor(user);

    final NavigationTarget resolved;
    if (scenario.deepLink == null) {
      resolved = TargetState.instance.defaultRoute;
    } else {
      TargetState.instance.fromUri(NavigationNotifier.instance, Uri.parse(scenario.deepLink!));
      resolved = TargetState.instance.navigationTarget;
    }

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // Only the framework fallback pages and the example error page are safe to
    // mount here; the app's real screens need Firebase.
    final bool renderable = resolved.path.startsWith("/fframe-") || resolved.title == "error";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(scenario.description),
              const SizedBox(height: 4),
              Text(
                "Resolved route: ${resolved.path.isEmpty ? "(${resolved.title})" : resolved.path}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: renderable
              ? resolved.contentPane!
              : Center(
                  child: Text(
                    "Routes into the app at \"${resolved.path}\" (${resolved.title}).\nThe real screen needs Firebase and is not mounted in this preview.",
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ],
    );
  }
}
