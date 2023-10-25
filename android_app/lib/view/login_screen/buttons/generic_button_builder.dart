import 'package:flutter/material.dart';

@immutable
class GenericButtonBuilder extends StatelessWidget {
  /// This is a builder class for signin button
  ///
  /// Icon can be used to define the signin method
  /// User can use Flutter built-in Icons or font-awesome flutter's Icon
  //ikonka
  final IconData? icon;

  /// Override the icon section with a image logo
  /// For example, Google requires a colorized logo,
  /// which FontAwesome cannot display. If both image
  /// and icon are provided, image will take precedence
  //obrazek (chyba)
  final Widget? image;

  /// the button's text
  final String text;

  /// The size of the label font
  final double fontSize;

  /// backgroundColor is required but textColor is default to `Colors.white`
  /// splashColor is defalt to `Colors.white30`
  final Color? textColor;
  final Color? iconColor;
  final Color? backgroundColor;

  /// onPressed should be specified as a required field to indicate the callback.
  final Function onPressed;

  /// padding is default to `EdgeInsets.all(3.0)`
  final EdgeInsets? padding, innerPadding;

  /// shape is to specify the custom shape of the widget.
  /// However the flutter widgets contains restriction or bug
  /// on material button, hence, comment out.
  final ShapeBorder? shape;

  /// elevation has defalt value of 2.0
  final double elevation;

  /// the height of the button
  final double? height;

  /// width is default to be 1/1.5 of the screen
  final double? width;

  /// The constructor is self-explanatory.
  GenericButtonBuilder({
    Key? key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
    this.icon,
    this.image,
    this.fontSize = 14.0,
    this.textColor,
    this.iconColor,
    this.padding,
    this.innerPadding,
    this.elevation = 2.0,
    this.shape,
    this.height,
    this.width,
  });

  /// The build funtion will be help user to build the signin button widget.
  @override
  Widget build(BuildContext context) {
      return MaterialButton(
        key: key,
        height: height,
        elevation: 0,
        padding: padding ?? EdgeInsets.all(0),
        color: backgroundColor,
        onPressed: onPressed as void Function()?,
        child: _getButtonChild(context),
        shape: shape ?? ButtonTheme.of(context).shape,
      );
  }

  /// Get the inner content of a button
  Container _getButtonChild(BuildContext context) {
    return Container(color: Colors.white10,
      constraints: BoxConstraints(
        maxWidth: width ?? 220,
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: innerPadding ??
                  EdgeInsets.symmetric(
                    horizontal: 0,
                  ),
              child: _getIconOrImage(context),
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get the icon or image widget
  Widget? _getIconOrImage(BuildContext context) {
    if (image != null) {
      return image;
    }
    return Padding( 
      padding: EdgeInsets.all(5),
      child:  Icon(
        icon,
        size: 25,
        color: iconColor != null ? iconColor : textColor,
      )
    );
  }

}
