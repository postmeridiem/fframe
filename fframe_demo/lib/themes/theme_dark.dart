import 'package:flutter/material.dart';
import 'package:fframe_demo/themes/config.dart';

final darkModeConfig = DarkModeThemeConfig();

final ThemeData appDarkTheme = ThemeData(
  fontFamily: darkModeConfig.fonts.mainFont,
  scaffoldBackgroundColor: darkModeConfig.constBackgroundColor,
  indicatorColor: darkModeConfig.constPrimaryAccentColor,
  dividerColor: darkModeConfig.constDividerColor,
  colorScheme: ColorScheme(
    brightness: darkModeConfig.brightness,
    primary: darkModeConfig.constOnPrimaryColor,
    onPrimary: darkModeConfig.constPrimaryColor,
    secondary: darkModeConfig.constSecondaryColor,
    onSecondary: darkModeConfig.constOnSecondaryColor,
    tertiary: darkModeConfig.constTertiaryColor,
    onTertiary: darkModeConfig.constOnTertiaryColor,
    surface: darkModeConfig.constPrimaryColor,
    onSurface: darkModeConfig.constOnPrimaryColor,
    primaryContainer: darkModeConfig.constPrimaryColor,
    onPrimaryContainer: darkModeConfig.constOnPrimaryColor,
    secondaryContainer: darkModeConfig.constSecondaryColor,
    onSecondaryContainer: darkModeConfig.constOnSecondaryColor,
    background: darkModeConfig.constBackgroundColor,
    onBackground: darkModeConfig.constPrimaryAccentColor,
    surfaceVariant: const Color(0xFFFF00DD),
    onSurfaceVariant: darkModeConfig.constOnBackgroundColorFaded,
    error: const Color(0xffd32f2f),
    onError: const Color(0xff000000),
    outline: const Color(0xFFFF00C8),
  ),

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      backgroundColor: darkModeConfig.constTertiaryColor,
      color: darkModeConfig.constOnTertiaryColor,
    ),
    floatingLabelStyle: TextStyle(
      backgroundColor: darkModeConfig.constTertiaryColor,
      color: darkModeConfig.constOnTertiaryColor,
    ),
    helperStyle: TextStyle(
      backgroundColor: darkModeConfig.constTertiaryColor,
      color: darkModeConfig.constOnTertiaryColor,
    ),
    hintStyle: TextStyle(
      backgroundColor: darkModeConfig.constTertiaryColor,
      color: darkModeConfig.constOnTertiaryColor,
    ),
    errorStyle: TextStyle(
      backgroundColor: darkModeConfig.constTertiaryColor,
      color: darkModeConfig.constOnTertiaryColor,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: darkModeConfig.constPrimaryAccentColor,
    focusColor: darkModeConfig.constOnPrimaryColor,
    backgroundColor: darkModeConfig.constPrimaryColor,
  ),
  cardTheme: CardTheme(
    color: darkModeConfig.constSecondaryColor,
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
    labelColor: darkModeConfig.constPrimaryAccentColor,
    unselectedLabelColor: darkModeConfig.constUnselectedColor,
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
//   textTheme: TextTheme(
  //     display4: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display3: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display2: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display1: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     headline: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     title: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     subhead: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     body2: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     body1: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     caption: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     button: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     subtitle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     overline: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   ),
  //   primaryTextTheme: TextTheme(
  //     display4: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display3: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display2: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display1: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     headline: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     title: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     subhead: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     body2: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     body1: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     caption: TextStyle(
  //     color: Color( 0xb3ffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     button: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     subtitle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     overline: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   ),
  //   accentTextTheme: TextTheme(
  //     display4: TextStyle(
  //     color: Color( 0x8a000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display3: TextStyle(
  //     color: Color( 0x8a000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display2: TextStyle(
  //     color: Color( 0x8a000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     display1: TextStyle(
  //     color: Color( 0x8a000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     headline: TextStyle(
  //     color: Color( 0xdd000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     title: TextStyle(
  //     color: Color( 0xdd000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     subhead: TextStyle(
  //     color: Color( 0xdd000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     body2: TextStyle(
  //     color: Color( 0xdd000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     body1: TextStyle(
  //     color: Color( 0xdd000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     caption: TextStyle(
  //     color: Color( 0x8a000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     button: TextStyle(
  //     color: Color( 0xdd000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     subtitle: TextStyle(
  //     color: Color( 0xff000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //     overline: TextStyle(
  //     color: Color( 0xff000000 ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   ),
  //   inputDecorationTheme:   InputDecorationTheme(
  //   labelStyle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   helperStyle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   hintStyle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   errorStyle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   errorMaxLines: null,
  //   hasFloatingPlaceholder: true,
  //   isDense: false,
  //   contentPadding: EdgeInsets.only(top:12,bottom:12,left:0, right:0),
  //   isCollapsed : false,
  //   prefixStyle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   suffixStyle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   counterStyle: TextStyle(
  //     color: Color( 0xffffffff ),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   filled: false,
  //   fillColor: Color( 0x00000000 ),
  //   errorBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   focusedBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   focusedErrorBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   disabledBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   enabledBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   border: UnderlineInputBorder(
  //     borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  // ),
);
