import 'package:flutter/material.dart';
import 'package:transaction_dashboard/themes/app_theme.dart';
import 'themes.dart';
class AppConstants {

  static const double _fs10 = 10.0;
  static const double _fs12 = 12.0;
  static const double _fs14 = 14.0;
  static const double _fs16 = 16.0;
  static const double _fs18 = 18.0;

  static const heading = Heading(
    h1: TextStyle(
      fontSize: _fs18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    h2: TextStyle(
      fontSize: _fs16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    h3: TextStyle(
      fontSize: _fs14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static const body = Body(
    bodyS: TextStyle(
      fontSize: _fs10,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyM: TextStyle(
      fontSize: _fs12,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyL: TextStyle(
      fontSize: _fs14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  );
}