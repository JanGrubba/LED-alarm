import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/widget/accept_button.dart';

typedef OnAcceptColor(Color chooseColor);

class ColorPickerTile extends StatefulWidget {
  final OnAcceptColor onPress;
  final Color? initColor;

  const ColorPickerTile({Key? key, required this.onPress, this.initColor = Colors.white}) : super(key: key);

  @override
  _ColorPickerTileState createState() => _ColorPickerTileState();
}

class _ColorPickerTileState extends State<ColorPickerTile> {
  late Color currentColor;

  @override
  void initState() {
    currentColor = (widget.initColor != null) ? widget.initColor! : Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.color,
          style: MyTextStyle.getAppBarTextStyleWithMatchedColor(context),
        ),
        ElevatedButton(
          onPressed: () => _onPress(),
          child: null,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            elevation: MaterialStateProperty.all(5),
            backgroundColor: MaterialStateProperty.all(currentColor),
          ),
        ),
      ],
    );
  }

  void _onPress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                child: SlidePicker(
                  pickerColor: currentColor,
                  onColorChanged: changeColor,
                  paletteType: PaletteType.rgb,
                  enableAlpha: false,
                  displayThumbColor: true,
                  showLabel: true,
                  showIndicator: true,
                  indicatorBorderRadius: const BorderRadius.vertical(
                    top: const Radius.circular(10.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AcceptButton(
                    onPressed: () => widget.onPress(currentColor),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void changeColor(Color color) => setState(() => currentColor = color);
}
