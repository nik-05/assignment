import 'package:flutter/material.dart';
import 'themes.dart';

class AppTheme {
  static const Color cardColor = Colors.white;
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color pending = Color.fromARGB(255, 180, 163, 13);

  static final  AppFont font = AppFont(
    heading: AppConstants.heading,
    body: AppConstants.body,
  );

  static final TextColor textColor = TextColor(
    primary: Colors.black,
    secondary: Colors.white,
    tertiary: Colors.blue,
  );

}

class TextColor {
  final Color primary;
  final Color secondary;
  final Color tertiary;

  const TextColor({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });
}

class AppFont {
  final Heading heading;
  final Body body;

  AppFont({required this.heading, required this.body});
}

class Heading {
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  
  const Heading({required this.h1, required this.h2, required this.h3});

}

class Body {
  final TextStyle bodyS;
  final TextStyle bodyM;
  final TextStyle bodyL;

  const Body({required this.bodyS, required this.bodyM, required this.bodyL});
}