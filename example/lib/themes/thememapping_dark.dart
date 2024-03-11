// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:example/themes/config.dart';

// this file is used to map the simplified configuration as set up in config.dart to
// the myriad of different flutter components as to be sane in the context of FlutFrame

// first try working with the config.dart in this directory before making changes here

final darkModeConfig = DarkModeThemeConfig();

final ThemeData appDarkTheme = ThemeData(
  fontFamily: darkModeConfig.fonts.mainFont,
  scaffoldBackgroundColor: darkModeConfig.constBackgroundColor,
  indicatorColor: darkModeConfig.constPrimaryAccentColor,
  dividerColor: darkModeConfig.constDividerColor,
  disabledColor: Colors.grey.shade400,
  unselectedWidgetColor: darkModeConfig.constUnselectedColor,
  errorColor: darkModeConfig.signalColors.constErrorColor,
  hintColor: darkModeConfig.signalColors.constSuccessColor,
  shadowColor: darkModeConfig.constPrimaryColor,
  colorScheme: ColorScheme(
    brightness: darkModeConfig.brightness,
    background: darkModeConfig.constBackgroundColor,
    onBackground: darkModeConfig.constPrimaryAccentColor,
    primary: darkModeConfig.constOnPrimaryColor,
    onPrimary: darkModeConfig.constPrimaryColor,
    secondary: darkModeConfig.constSecondaryColor,
    onSecondary: darkModeConfig.constOnSecondaryColor,
    tertiary: darkModeConfig.constTertiaryColor,
    onTertiary: darkModeConfig.constOnTertiaryColor,
    surface: darkModeConfig.constPrimaryColor,
    onSurface: darkModeConfig.constOnPrimaryColor,
    surfaceVariant: darkModeConfig.constSurfaceVariantColor,
    onSurfaceVariant: darkModeConfig.constOnSurfaceVariantColor,
    primaryContainer: darkModeConfig.constPrimaryColor,
    onPrimaryContainer: darkModeConfig.constOnPrimaryColor,
    secondaryContainer: darkModeConfig.constSecondaryColor,
    onSecondaryContainer: darkModeConfig.constOnSecondaryColor,
    error: darkModeConfig.signalColors.constErrorColor,
    onError: darkModeConfig.constOnPrimaryColor,
    outline: darkModeConfig.constOnPrimaryColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: darkModeConfig.constTertiaryColor,
    labelStyle: TextStyle(
      color: darkModeConfig.constUnselectedColor,
    ),
    floatingLabelStyle: TextStyle(
      color: darkModeConfig.constOnTertiaryColor,
    ),
    helperStyle: TextStyle(
      color: darkModeConfig.constOnTertiaryColor,
    ),
    hintStyle: TextStyle(
      color: darkModeConfig.constOnTertiaryColor,
    ),
    errorStyle: TextStyle(
      color: darkModeConfig.signalColors.constErrorColor,
    ),
  ),
  cardTheme: CardTheme(
    color: darkModeConfig.constSecondaryColor,
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: darkModeConfig.constPrimaryAccentColor,
    unselectedLabelColor: darkModeConfig.constUnselectedColor,
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateColor.resolveWith(
      (states) {
        return darkModeConfig.constPrimaryAccentColor;
      },
    ),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    selectedColor: darkModeConfig.constPrimaryAccentColor,
  ),
  switchTheme: SwitchThemeData(
    overlayColor: MaterialStateColor.resolveWith(
      (states) {
        return darkModeConfig.constPrimaryAccentColor;
      },
    ),
  ),
);
