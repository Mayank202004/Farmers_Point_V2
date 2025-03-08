import 'package:flutter/material.dart';

const int primary = 0xFF2D432D;

class AppColor {
  static const int primary = 0xFF2D432D;
}

final ThemeData theme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.0,
    surfaceTintColor: Colors.white,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(primary),
    onSurface: Color(primary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(primary),
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: const TextTheme(
    titleSmall: TextStyle(color: Colors.black),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: const Color(primary),
      foregroundColor: Colors.white,
    ),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    iconTheme: MaterialStatePropertyAll(
      IconThemeData(color: Colors.white),
    ),
    indicatorColor: Colors.transparent,
    backgroundColor: Color(primary),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    height: 60,
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(primary)),
      borderRadius: BorderRadius.circular(20),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(),
      borderRadius: BorderRadius.circular(20),
    ),
  ),
);
