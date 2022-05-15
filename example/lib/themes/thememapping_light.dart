import 'package:flutter/material.dart';
import 'package:example/themes/config.dart';

// this file is used to map the simplified configuration as set up in config.dart to
// the myriad of different flutter components as to be sane in the context of FlutFrame

// first try working with the config.dart in this directory before making changes here

final lightModeConfig = LightModeThemeConfig();

final ThemeData appLightTheme = ThemeData(
  fontFamily: lightModeConfig.fonts.mainFont,
  scaffoldBackgroundColor: lightModeConfig.constBackgroundColor,
  indicatorColor: lightModeConfig.constPrimaryAccentColor,
  dividerColor: lightModeConfig.constDividerColor,
  unselectedWidgetColor: lightModeConfig.constUnselectedColor,
  errorColor: lightModeConfig.signalColors.constErrorColor,
  hintColor: lightModeConfig.signalColors.constSuccessColor,
  colorScheme: ColorScheme(
    brightness: lightModeConfig.brightness,
    primary: lightModeConfig.constPrimaryColor,
    onPrimary: lightModeConfig.constOnPrimaryColor,
    secondary: lightModeConfig.constSecondaryColor,
    onSecondary: lightModeConfig.constOnSecondaryColor,
    tertiary: lightModeConfig.constTertiaryColor,
    onTertiary: lightModeConfig.constOnTertiaryColor,
    surface: lightModeConfig.constSecondaryColor,
    onSurface: lightModeConfig.constOnSecondaryColor,
    primaryContainer: lightModeConfig.constPrimaryColor,
    onPrimaryContainer: lightModeConfig.constOnPrimaryColor,
    secondaryContainer: lightModeConfig.constSecondaryColor,
    onSecondaryContainer: lightModeConfig.constOnSecondaryColor,
    background: lightModeConfig.constBackgroundColor,
    onBackground: lightModeConfig.constPrimaryAccentColor,
    surfaceVariant: const Color(0xFFFF00DD),
    onSurfaceVariant: lightModeConfig.constOnBackgroundColorFaded,
    error: lightModeConfig.signalColors.constErrorColor,
    onError: const Color(0xff000000),
    outline: const Color(0xFFFF00C8),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: lightModeConfig.constTertiaryColor,
    labelStyle: TextStyle(
      color: lightModeConfig.constUnselectedColor,
    ),
    floatingLabelStyle: TextStyle(
      color: lightModeConfig.constOnTertiaryColor,
    ),
    helperStyle: TextStyle(
      color: lightModeConfig.constOnTertiaryColor,
    ),
    hintStyle: TextStyle(
      color: lightModeConfig.constOnTertiaryColor,
    ),
    errorStyle: TextStyle(
      color: lightModeConfig.signalColors.constErrorColor,
    ),
  ),
  cardTheme: CardTheme(
    color: lightModeConfig.constSecondaryColor,
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: lightModeConfig.constPrimaryAccentColor,
    unselectedLabelColor: lightModeConfig.constUnselectedColor,
  ),
);
