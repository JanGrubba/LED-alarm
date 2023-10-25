import 'package:flutter/material.dart';

enum AppTheme { Light, Green, Dark, Black }

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.Light: ThemeData.light().copyWith(
    primaryColor: Color(0xFF698DDB),
    primaryColorLight: Colors.white,
    primaryColorDark: Color(0xFF5E7EC4) ,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF698ddb)),
  ),
  AppTheme.Dark: ThemeData.light().copyWith(
    primaryColor: Colors.grey,
    primaryColorLight: Colors.white,
    primaryColorDark: Color(0xFF616161) ,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black87),
  ),
  AppTheme.Black: ThemeData.dark().copyWith(
    primaryColorDark: ThemeData.dark().primaryColorLight
  ),
  AppTheme.Green: ThemeData.light().copyWith(
    primaryColor: Color(0xFF36AB5C),
    primaryColorLight: Colors.white,
    primaryColorDark: Color(0xFF309952),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0x993DC477)),
  )
};

extension AppThemeExtension on AppTheme {
  String get name {
    return this.toString();
  }
}

AppTheme fromString(String value) {
  return AppTheme.values.firstWhere((e) => e.toString() == value);
}

Color getBackgroundColor(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark ? Color(0xAA1F1F1F) : Color(0xAA698ddb);
}

Color getInvertedBackgroundColor(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark ? Color(0xAA698ddb) : Color(0xAA1F1F1F);
}

Color getButtonColor(BuildContext context) {
  return Color(0xAAdfe2e8);
}

Color getButtonTextColor(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark ? Colors.white : Color(0xAA373e48);
}
