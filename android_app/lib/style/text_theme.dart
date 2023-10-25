import 'package:flutter/material.dart';

class MyTextStyle {
  static const double _LargeTextSize = 26.0;
  static const double _MediumTextSize = 20.0;
  static const double _Body1TextSize = 16.0;
  static const double _Body2TextSize = 14.0;

  static const TextStyle AppBarTextStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: _MediumTextSize);

  static const TextStyle TitleTextStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: _LargeTextSize);

  static const TextStyle Body1TextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: _Body1TextSize);

  static const TextStyle Subtitle1TextStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: _Body1TextSize);

  static const TextStyle Body2TextStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: _Body2TextSize);

  static TextStyle getAppBarTextStyleWithMatchedColor(BuildContext context) =>
      AppBarTextStyle.copyWith(color: _getColor(context));

  static TextStyle getTitleTextStyleWithMatchedColor(BuildContext context) =>
      TitleTextStyle.copyWith(color: _getColor(context));

  static TextStyle getBody1TextStyleWithMatchedColor(BuildContext context) =>
      Body1TextStyle.copyWith(color: _getColor(context));

  static TextStyle getSubtitle1TextStyleWithMatchedColor(BuildContext context) =>
      Subtitle1TextStyle.copyWith(color: _getColor(context));

  static TextStyle getBody2TextStyleWithMatchedColor(BuildContext context) =>
      Body2TextStyle.copyWith(color: _getColor(context));

  static Color _getColor(BuildContext context) =>
      getMatchingColorByBackgroundColor(backgroundColor: Theme.of(context).primaryColor);

  static Color getMatchingColorByBackgroundColor(
          {required Color backgroundColor, Color? lightColor = Colors.white, Color? darkColor = Colors.black}) =>
      (ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark) ? lightColor! : darkColor!;

  static Color getMatchingColorByTheme(
          {required BuildContext context, Color? lightColor = Colors.white, Color? darkColor = Colors.black}) =>
      (ThemeData.estimateBrightnessForColor(Theme.of(context).primaryColor) == Brightness.dark)
          ? lightColor!
          : darkColor!;
}
