import 'package:flutter/material.dart';

class MyThemeData {
  final String title;
  final String backgroundImg;
  final ThemeData themeData;
  MyThemeData(
      {required this.title,
      required this.backgroundImg,
      required this.themeData});
}

abstract class MyTheme {
  static List<MyThemeData> get list => [
        MyThemeData(
            title: 'Love',
            backgroundImg: 'assets/images/love.jpg',
            themeData: _defaultTheme(
                primarySwatch:
                    MaterialColor(0xff01014e, _colorSwatch(1, 1, 78)),
                canvasColor: const Color(0xff01014e),
                primaryColor: const Color(0xff00A3FF))),
        MyThemeData(
            title: 'Hope',
            backgroundImg: 'assets/images/hope.jpg',
            themeData: _defaultTheme(
                primarySwatch:
                    MaterialColor(0xff230004, _colorSwatch(35, 0, 4)),
                canvasColor: const Color(0xff230004),
                primaryColor: const Color(0xffFFA500))),
        MyThemeData(
            title: 'Moon',
            backgroundImg: 'assets/images/moon.jpg',
            themeData: _defaultTheme(
                primarySwatch:
                    MaterialColor(0xff350A1F, _colorSwatch(35, 0, 4)),
                canvasColor: const Color(0xff350A1F),
                primaryColor: const Color(0xffF943AF)))
      ];

  /// _colorSwatch method or function take RGB color as argument and after processing
  ///  it will return Map<int, Color> where int consist colors varients
  static Map<int, Color> _colorSwatch(
    int r,
    int g,
    int b,
  ) =>
      {
        50: Color.fromRGBO(r, g, b, 0.1),
        100: Color.fromRGBO(r, g, b, 0.2),
        200: Color.fromRGBO(r, g, b, 0.3),
        300: Color.fromRGBO(r, g, b, 0.4),
        400: Color.fromRGBO(r, g, b, 0.5),
        500: Color.fromRGBO(r, g, b, 0.6),
        600: Color.fromRGBO(r, g, b, 0.7),
        700: Color.fromRGBO(r, g, b, 0.8),
        800: Color.fromRGBO(r, g, b, 0.9),
        900: Color.fromRGBO(r, g, b, 1),
      };
  static ThemeData _defaultTheme(
          {required MaterialColor primarySwatch,
          required Color canvasColor,
          required Color primaryColor}) =>
      ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: canvasColor,
          backgroundColor: canvasColor,
          primaryColor: primaryColor,
          indicatorColor: primaryColor,
//SnackBar Theme
          snackBarTheme: SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              backgroundColor: canvasColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),

//Button Theme
          listTileTheme: ListTileThemeData(
              tileColor: Colors.white24,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
//Card Theme
          cardTheme: CardTheme(
            color: Colors.white30,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          dialogTheme: DialogTheme(backgroundColor: canvasColor),
          sliderTheme: SliderThemeData(
              thumbColor: primaryColor,
              activeTrackColor: primaryColor.withOpacity(0.3),
              inactiveTrackColor: Colors.black26),
          switchTheme: SwitchThemeData(
              trackColor: MaterialStateColor.resolveWith(
                  (states) => primaryColor.withOpacity(0.5)),
              thumbColor:
                  MaterialStateColor.resolveWith((states) => primaryColor)),

//AppBar Theme
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            subtitle1: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            subtitle2: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
            headline4: TextStyle(color: Colors.white),
            headline5: TextStyle(
              color: Colors.white,
            ),
            headline6: TextStyle(
              color: Colors.white,
            ),
            caption: TextStyle(
              color: Colors.white60,
            ),
          ));
}
