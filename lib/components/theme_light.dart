import 'package:flutter/material.dart';

//TODO: update colorScheme variables to what is listed in dark_theme

final ThemeData appLightTheme = ThemeData(
  fontFamily: 'Raleway',
  primarySwatch: MaterialColor(4279185720, {
    50: Color(0xffebf7fa),
    100: Color(0xffd7eff4),
    200: Color(0xffafdfe9),
    300: Color(0xff86d0df),
    400: Color(0xff5ec0d4),
    500: Color(0xff36b0c9),
    600: Color(0xff2b8da1),
    700: Color(0xff206a79),
    800: Color(0xff164650),
    900: Color(0xff0b2328)
  }),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff0f3138),
    onPrimary: Color(0xffffffff),
    secondary: Color(0xff36b0c9),
    onSecondary: Color(0xff000000),
    surface: Color(0xffffffff),
    onSurface: Color(0xFF353535),
    background: Color(0xffafdfe9),
    onBackground: Color(0xffffffff),
    error: Color(0xffd32f2f),
    onError: Color(0xffffffff),
  ),
  dividerColor: Colors.grey[300],
  buttonTheme: ButtonThemeData(
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
    buttonColor: Color(0xffe0e0e0),
    disabledColor: Color(0x61000000),
    highlightColor: Color(0x29000000),
    splashColor: Color(0x1f000000),
    focusColor: Color(0x1f000000),
    hoverColor: Color(0x0a000000),
    colorScheme: ColorScheme(
      primary: Color(0xff0f3138),
      onPrimary: Color(0xffffffff),
      secondary: Color(0xff36b0c9),
      onSecondary: Color(0xff000000),
      surface: Color(0xffffffff),
      onSurface: Color(0xff000000),
      background: Color(0xffafdfe9),
      onBackground: Color(0xffffffff),
      error: Color(0xffd32f2f),
      onError: Color(0xffffffff),
      brightness: Brightness.light,
    ),
  ),
  // textTheme: TextTheme(
  //   display4: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display3: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display2: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display1: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   headline: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   title: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   subhead: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   body2: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   body1: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   caption: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   button: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   subtitle: TextStyle(
  //     color: Color(0xff000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   overline: TextStyle(
  //     color: Color(0xff000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  // ),
  // primaryTextTheme: TextTheme(
  //   display4: TextStyle(
  //     color: Color(0xb3ffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display3: TextStyle(
  //     color: Color(0xb3ffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display2: TextStyle(
  //     color: Color(0xb3ffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display1: TextStyle(
  //     color: Color(0xb3ffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   headline: TextStyle(
  //     color: Color(0xffffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   title: TextStyle(
  //     color: Color(0xffffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   subhead: TextStyle(
  //     color: Color(0xffffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   body2: TextStyle(
  //     color: Color(0xffffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   body1: TextStyle(
  //     color: Color(0xffffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   caption: TextStyle(
  //     color: Color(0xb3ffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   button: TextStyle(
  //     color: Color(0xffffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   subtitle: TextStyle(
  //     color: Color(0xffffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   overline: TextStyle(
  //     color: Color(0xffffffff),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  // ),
  // accentTextTheme: TextTheme(
  //   display4: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display3: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display2: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   display1: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   headline: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   title: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   subhead: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   body2: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   body1: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   caption: TextStyle(
  //     color: Color(0x8a000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   button: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   subtitle: TextStyle(
  //     color: Color(0xff000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   overline: TextStyle(
  //     color: Color(0xff000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  // ),
  // inputDecorationTheme: InputDecorationTheme(
  //   labelStyle: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   helperStyle: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   hintStyle: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   errorStyle: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   errorMaxLines: null,
  //   hasFloatingPlaceholder: true,
  //   isDense: false,
  //   contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
  //   isCollapsed: false,
  //   prefixStyle: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   suffixStyle: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   counterStyle: TextStyle(
  //     color: Color(0xdd000000),
  //     fontSize: null,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //   ),
  //   filled: false,
  //   fillColor: Color(0x00000000),
  //   errorBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Color(0xff000000),
  //       width: 1,
  //       style: BorderStyle.solid,
  //     ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   focusedBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Color(0xff000000),
  //       width: 1,
  //       style: BorderStyle.solid,
  //     ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   focusedErrorBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Color(0xff000000),
  //       width: 1,
  //       style: BorderStyle.solid,
  //     ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   disabledBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Color(0xff000000),
  //       width: 1,
  //       style: BorderStyle.solid,
  //     ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   enabledBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Color(0xff000000),
  //       width: 1,
  //       style: BorderStyle.solid,
  //     ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  //   border: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Color(0xff000000),
  //       width: 1,
  //       style: BorderStyle.solid,
  //     ),
  //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   ),
  // ),
  iconTheme: IconThemeData(
    color: Color(0xdd000000),
    opacity: 1,
    size: 24,
  ),
  primaryIconTheme: IconThemeData(
    color: Color(0xffffffff),
    opacity: 1,
    size: 24,
  ),
  sliderTheme: SliderThemeData(
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
    labelColor: Color(0xff0f3138),
    unselectedLabelColor: Color(0xFF2C2C2C),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Color(0x1f000000),
    brightness: Brightness.light,
    deleteIconColor: Color(0xde000000),
    disabledColor: Color(0x0c000000),
    labelPadding: EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
    labelStyle: TextStyle(
      color: Color(0xde000000),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
    secondaryLabelStyle: TextStyle(
      color: Color(0x3d000000),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    secondarySelectedColor: Color(0x3d0f3138),
    selectedColor: Color(0x3d000000),
    shape: StadiumBorder(
        side: BorderSide(
      color: Color(0xff000000),
      width: 0,
      style: BorderStyle.none,
    )),
  ),
  dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
    side: BorderSide(
      color: Color(0xff000000),
      width: 0,
      style: BorderStyle.none,
    ),
    borderRadius: BorderRadius.all(Radius.circular(0.0)),
  )),
);
