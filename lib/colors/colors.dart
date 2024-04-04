import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFFFEEEA),
  100: Color(0xFFFFD5C9),
  200: Color(0xFFFFB9A6),
  300: Color(0xFFFE9C82),
  400: Color(0xFFFE8767),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFFFE6A45),
  700: Color(0xFFFE5F3C),
  800: Color(0xFFFE5533),
  900: Color(0xFFFD4224),
});
const int _primaryPrimaryValue = 0xFFFE724C;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_primaryAccentValue),
  400: Color(0xFFFFD6D0),
  700: Color(0xFFFFBFB7),
});
const int _primaryAccentValue = 0xFFFFFFFF;

const MaterialColor backgroundgray =
    MaterialColor(_backgroundgrayPrimaryValue, <int, Color>{
  50: Color(0xFFF7F7F9),
  100: Color(0xFFEAECEF),
  200: Color(0xFFDDE0E5),
  300: Color(0xFFCFD3DA),
  400: Color(0xFFC4C9D2),
  500: Color(_backgroundgrayPrimaryValue),
  600: Color(0xFFB3BAC5),
  700: Color(0xFFABB2BD),
  800: Color(0xFFA3AAB7),
  900: Color(0xFF949CAB),
});
const int _backgroundgrayPrimaryValue = 0xFFBAC0CA;

const MaterialColor backgroundgrayAccent =
    MaterialColor(_backgroundgrayAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_backgroundgrayAccentValue),
  400: Color(0xFFE1ECFF),
  700: Color(0xFFC8DCFF),
});
const int _backgroundgrayAccentValue = 0xFFFFFFFF;
