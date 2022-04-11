import 'package:flutter/material.dart';

class Fonts {
  // Main font (changing this needs the new font assets to be included in the project!)
  String mainFont = 'OpenSans';
  // Monospace font (changing this needs the new font assets to be included in the project!)
  String monoFont = 'RobotoMono';
}

class SignalColors {
  // Basic Signal Colors
  Color constGreenSuccess = const Color(0xFF10743D);
  Color constRedFailure = const Color(0xFF8B3737);
}

class DarkModeThemeConfig {
  // DARK MODE =======
  final brightness = Brightness.dark;
  // color that sets the primary accent color
  Color constPrimaryAccentColor = Color.fromARGB(255, 5, 202, 198);

  // color that sets the appbar, navrail, contextwidgets and FAB
  Color constPrimaryColor = const Color(0xFF1B020B);
  Color constOnPrimaryColor = const Color(0xffffffff);

  // color that sets 'secondary' level control widgets
  // (application surfaces and things that are not navrail, contextwidgets, FAB or appbar...)
  Color constSecondaryColor = const Color(0xFF310414);
  Color constOnSecondaryColor = const Color(0xFFEEEEEE);

  // color that sets 'tertiary' level control widgets
  // (the background of fields and the text that goes in there)
  Color constTertiaryColor = const Color(0xFF160209);
  Color constOnTertiaryColor = const Color(0xFFEEEEEE);

  // color for unselected elements
  Color constUnselectedColor = const Color(0xB2E7E7E7);

  // color for dividers and lines
  Color constDividerColor = const Color(0xB21B1B1B);

  // color that sets the main background behind everything
  Color constBackgroundColor = const Color(0xFF0E0D0D);
  Color constOnBackgroundColor = const Color(0xFFEEEEEE);
  Color constOnBackgroundColorFaded = const Color(0xFF330216);

  // signal color import
  SignalColors signalColors = SignalColors();

  // font import
  Fonts fonts = Fonts();
}

class LightModeThemeConfig {
  // LIGHT MODE =======
  final brightness = Brightness.light;
  // color that sets the primary accent color
  Color constPrimaryAccentColor = Color.fromARGB(255, 0, 139, 137);

  // color that sets the appbar, navrail, contextwidgets and FAB
  Color constPrimaryColor = const Color(0xFF610525);
  Color constOnPrimaryColor = const Color(0xFFFFFFFF);

  // color that sets 'secondary' level control widgets
  // (application surfaces and things that are not navrail, contextwidgets, FAB or appbar...)
  // Color constSecondaryColor = const Color(0xFFEBB3CB);
  Color constSecondaryColor = const Color(0xFFFFF8FB);
  Color constOnSecondaryColor = const Color(0xB21D1D1D);

  // color that sets 'tertiary' level control widgets
  // (the background of fields and the text that goes in there)
  Color constTertiaryColor = const Color(0xFFFFFFFF);
  Color constOnTertiaryColor = const Color(0xB247138B);

  // color for unselected elements
  Color constUnselectedColor = const Color(0xB2474747);

  // color for dividers and lines
  Color constDividerColor = const Color(0xB2B6B6B6);

  // color that sets the main background behind everything
  Color constBackgroundColor = const Color(0xFFECE2E2);
  Color constOnBackgroundColor = const Color(0xFF1B020B);
  Color constOnBackgroundColorFaded = const Color(0xFFDAC8CF);

  // signal color import
  SignalColors signalColors = SignalColors();

  // font import
  Fonts fonts = Fonts();
}
