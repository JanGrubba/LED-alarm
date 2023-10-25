import 'package:flutter/material.dart';
import 'package:led_alarm/util/common_package.dart';

class CancelButton extends StatelessWidget {
  final void Function()? onPressed;

  const CancelButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Theme.of(context).primaryColor,
        primary: Theme.of(context).bottomAppBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      onPressed: onPressed ?? () => Navigator.pop(context),
      child: Text(
        AppLocalizations.of(context)!.cancel,
        style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white),
      ),
    );
  }
}
