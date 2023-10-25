import 'package:flutter/material.dart';
import 'package:led_alarm/style/app_theme.dart';

import 'generic_button_builder.dart';

class GenericButton extends StatelessWidget {
  /// Here are the buttons builder which integrate with button builder
  /// and the buttons list.
  ///
  /// The `SignInButton` class already contains general used buttons.
  /// In case of other buttons, user can always use `SignInButtonBuilder`
  /// to build the signin button.

  /// onPressed function should be passed in as a required field.
  final Function onPressed;

  /// shape is to specify the custom shape of the widget.
  final ShapeBorder? shape;

  /// overrides the default button text
  final String? text;

  /// overrides the default button padding
  final EdgeInsets padding;

  // overrides the default button elevation
  final double elevation;

  final Widget? image;

  final IconData? icon;

  final Color? color;

  final Color? textColor;


  /// The constructor is fairly self-explanatory.
  GenericButton({
        required this.onPressed,
        this.padding = const EdgeInsets.all(0),
        this.shape,
        this.text,
        this.elevation = 2.0,
        this.icon,
        this.image,
        this.color,
        this.textColor
      });

  @override
  Widget build(BuildContext context) {
    return GenericButtonBuilder(
      elevation: elevation,
      key: ValueKey("Generic Button"),
      text: text ?? 'Generic button',
      textColor: getButtonTextColor(context),
      image: image!= null ? image : null,
      icon: icon != null ? icon : null,
      backgroundColor:
      color != null  ? color! : Colors.black26,
      onPressed: onPressed,
      padding: padding,
      innerPadding: EdgeInsets.all(0),
      shape: shape,
      height: 36.0,
    );
  }
}
