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
    error: const Color(0xffd32f2f),
    onError: const Color(0xff000000),
    outline: const Color(0xFFFF00C8),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      backgroundColor: lightModeConfig.constTertiaryColor,
      color: lightModeConfig.constOnTertiaryColor,
    ),
    floatingLabelStyle: TextStyle(
      backgroundColor: lightModeConfig.constTertiaryColor,
      color: lightModeConfig.constOnTertiaryColor,
    ),
    helperStyle: TextStyle(
      backgroundColor: lightModeConfig.constTertiaryColor,
      color: lightModeConfig.constOnTertiaryColor,
    ),
    hintStyle: TextStyle(
      backgroundColor: lightModeConfig.constTertiaryColor,
      color: lightModeConfig.constOnTertiaryColor,
    ),
    errorStyle: TextStyle(
      backgroundColor: lightModeConfig.constTertiaryColor,
      color: lightModeConfig.constOnTertiaryColor,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: lightModeConfig.constPrimaryAccentColor,
    focusColor: lightModeConfig.constOnPrimaryColor,
    backgroundColor: lightModeConfig.constPrimaryColor,
  ),
  cardTheme: CardTheme(
    color: lightModeConfig.constSecondaryColor,
  ),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    minWidth: 88,
    height: 36,
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Color(0xff000000),
        width: 0,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    alignedDropdown: false,
    buttonColor: Color(0xff2b8da1),
    disabledColor: Color(0x61ffffff),
    highlightColor: Color(0x29ffffff),
    splashColor: Color(0x1fffffff),
    focusColor: Color(0x1fffffff),
    hoverColor: Color(0x0affffff),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff0f3138),
      onPrimary: Color(0xffffffff),
      secondary: Color(0xff64ffda),
      onSecondary: Color(0xff000000),
      surface: Color(0xff616161),
      onSurface: Color(0xffffffff),
      background: Color(0xff616161),
      onBackground: Color(0xffffffff),
      error: Color(0xffd32f2f),
      onError: Color(0xff000000),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xffffffff),
    opacity: 1,
    size: 24,
  ),
  primaryIconTheme: const IconThemeData(
    color: Color(0xffffffff),
    opacity: 1,
    size: 24,
  ),
  sliderTheme: const SliderThemeData(
    activeTrackColor: null,
    inactiveTrackColor: null,
    disabledActiveTrackColor: null,
    disabledInactiveTrackColor: null,
    activeTickMarkColor: null,
    inactiveTickMarkColor: null,
    disabledActiveTickMarkColor: null,
    disabledInactiveTickMarkColor: null,
    thumbColor: null,
    disabledThumbColor: null,
    thumbShape: null,
    overlayColor: null,
    valueIndicatorColor: null,
    valueIndicatorShape: null,
    showValueIndicator: null,
    valueIndicatorTextStyle: TextStyle(
      color: Color(0xdd000000),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: lightModeConfig.constPrimaryAccentColor,
    unselectedLabelColor: lightModeConfig.constUnselectedColor,
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: Color(0x1fffffff),
    brightness: Brightness.dark,
    deleteIconColor: Color(0xdeffffff),
    disabledColor: Color(0x0cffffff),
    labelPadding: EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
    labelStyle: TextStyle(
      color: Color(0xdeffffff),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
    secondaryLabelStyle: TextStyle(
      color: Color(0x3dffffff),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    secondarySelectedColor: Color(0x3d212121),
    selectedColor: Color(0x3dffffff),
    shape: StadiumBorder(
        side: BorderSide(
      color: Color(0xff000000),
      width: 0,
      style: BorderStyle.none,
    )),
  ),
  dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
    side: BorderSide(
      color: Color(0xff000000),
      width: 0,
      style: BorderStyle.none,
    ),
    borderRadius: BorderRadius.all(Radius.circular(0.0)),
  )),
);
