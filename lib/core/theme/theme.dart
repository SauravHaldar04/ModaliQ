
import 'package:datahack/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final appTheme = ThemeData(
    colorSchemeSeed: Pallete.primaryColor,
    datePickerTheme: const DatePickerThemeData(
      headerForegroundColor: Pallete.primaryColor,
      // headerTextStyle: TextStyle(color: Pallete.backgroundColor, fontSize: 20),
      // inputDecoration: inputDecoration.copyWith(
      //   hintText: 'Select Date',
      //   hintStyle: TextStyle(color: Pallete.inactiveColor),
      // ),
    ),
    //primaryColor: Pallete.primaryColor,
    scaffoldBackgroundColor: Pallete.backgroundColor,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Pallete.primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Pallete.backgroundColor),
    ),
  );
  static final inputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.all(15),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Pallete.inactiveColor, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Pallete.primaryColor, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
