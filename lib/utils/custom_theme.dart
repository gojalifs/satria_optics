import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData customTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(251, 18, 16, 1),
      primary: const Color.fromRGBO(251, 18, 16, 1),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'Source_Sans_Pro',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(251, 18, 16, 1),
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color.fromRGBO(54, 54, 54, 1),
      filled: true,
      labelStyle: const TextStyle(
        color: Color.fromRGBO(189, 189, 189, 1),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        shape: const MaterialStatePropertyAll(
          CircleBorder(),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
      ),
    ),
    textTheme: const TextTheme(
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(fontSize: 18),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(fontSize: 14),
      bodyMedium: TextStyle(fontSize: 18),
      bodyLarge: TextStyle(fontSize: 22),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.red,
      type: BottomNavigationBarType.fixed,
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
