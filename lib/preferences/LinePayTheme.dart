import 'package:flutter/material.dart';
import 'package:linepay/preferences/LinePayColors.dart';


class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        primaryColor: line_pay_green,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: line_pay_yellow),
        dialogBackgroundColor: dialog_background,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Open Sans', //3

    );
  }
}