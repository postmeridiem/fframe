import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:example/screens/tabloader/tabloader.dart';

final tabloaderNavigationTarget = NavigationTarget(
  path: "tabloader",
  title: "Tabloader",
  // contentPane: const TabloaderScreen(tabloaderQueryState),
  destination: Destination(
    icon: const Icon(Icons.pest_control),
    navigationLabel: () => Text(
      L10n.string(
        'tabloaders',
        placeholder: 'Tabloaders',
        namespace: 'global',
      ),
    ),
  ),
  roles: ['user'],
  private: true,
  contentPane: const TabloaderScreen(),
);
