import 'package:flutter/material.dart';

class Fonts {
  // Main font (changing this needs the new font assets to be included in the project!)
  String mainFont = 'OpenSans';
  // Monospace font (changing this needs the new font assets to be included in the project!)
  String monoFont = 'RobotoMono';
}

class SignalColors {
  // Basic Signal Colors
  Color constAccentColor = const Color.fromARGB(255, 21, 206, 163);
  Color constWaitingColor = const Color.fromARGB(255, 72, 72, 72);
  Color constWarningColor = const Color.fromARGB(255, 241, 126, 32);
  Color constRunningColor = const Color.fromARGB(255, 203, 134, 235);
  Color constSuccessColor = const Color.fromARGB(255, 6, 178, 83);
  Color constErrorColor = const Color.fromARGB(255, 192, 64, 61);
}

class DarkModeThemeConfig {
  // DARK MODE =======
  final brightness = Brightness.dark;
  // color that sets the appbar, navrail, contextwidgets and FAB
  Color constPrimaryColor = const Color.fromARGB(255, 78, 4, 31);
  Color constOnPrimaryColor = const Color.fromARGB(255, 255, 255, 255);

  // color that sets 'secondary' level control widgets
  // (application surfaces and things that are not navrail, contextwidgets, FAB or appbar...)
  Color constSecondaryColor = const Color.fromARGB(255, 49, 4, 20);
  Color constOnSecondaryColor = const Color.fromARGB(255, 238, 238, 238);

  // color that sets 'tertiary' level control widgets
  // (the background of fields and the text that goes in there)
  Color constTertiaryColor = const Color.fromARGB(255, 36, 3, 15);
  Color constOnTertiaryColor = const Color.fromARGB(255, 238, 238, 238);

  // color that sets the primary accent color
  Color constPrimaryAccentColor = const Color.fromARGB(255, 5, 202, 198);

  // color for unselected elements
  Color constUnselectedColor = const Color.fromARGB(177, 233, 233, 233);

  // color for dividers and lines
  Color constDividerColor = const Color.fromARGB(177, 28, 28, 28);

  // color that sets the main background behind everything
  Color constBackgroundColor = const Color.fromARGB(255, 14, 13, 13);
  Color constOnBackgroundColor = const Color.fromARGB(255, 238, 238, 238);
  Color constOnBackgroundColorFaded = const Color.fromARGB(255, 51, 2, 22);

  // signal color import
  SignalColors signalColors = SignalColors();

  // font import
  Fonts fonts = Fonts();
}

class LightModeThemeConfig {
  // LIGHT MODE =======
  final brightness = Brightness.light;

  // color that sets the appbar, navrail, contextwidgets and FAB
  Color constPrimaryColor = const Color.fromARGB(255, 97, 5, 37);
  Color constOnPrimaryColor = const Color.fromARGB(255, 255, 255, 255);

  // color that sets 'secondary' level control widgets
  // (application surfaces and things that are not navrail, contextwidgets, FAB or appbar...)
  Color constSecondaryColor = const Color.fromARGB(255, 255, 247, 251);
  Color constOnSecondaryColor = const Color.fromARGB(176, 28, 28, 28);

  // color that sets 'tertiary' level control widgets
  // (the background of fields and the text that goes in there)
  Color constTertiaryColor = const Color.fromARGB(255, 255, 255, 255);
  Color constOnTertiaryColor = const Color.fromARGB(255, 107, 6, 42);

  // color that sets the primary accent color
  Color constPrimaryAccentColor = const Color.fromARGB(255, 0, 138, 136);

  // color for unselected elements
  Color constUnselectedColor = const Color.fromARGB(177, 71, 71, 71);

  // color for dividers and lines
  Color constDividerColor = const Color.fromARGB(177, 182, 182, 182);

  // color that sets the main background behind everything
  Color constBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  Color constOnBackgroundColor = const Color.fromARGB(255, 27, 2, 11);
  Color constOnBackgroundColorFaded = const Color.fromARGB(255, 218, 200, 207);

  // signal color import
  SignalColors signalColors = SignalColors();

  // font import
  Fonts fonts = Fonts();
}
