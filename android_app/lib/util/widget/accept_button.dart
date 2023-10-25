import 'package:flutter/material.dart';
import 'package:led_alarm/util/common_package.dart';

class AcceptButton extends StatelessWidget {
  final void Function()? onPressed;

  const AcceptButton({Key? key = const Key("AcceptButton"), required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor:  Theme.of(context).primaryColor,
        primary:  Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color:  Theme.of(context).primaryColor),
        ),
      ),
      onPressed: onPressed,
      child: Text(AppLocalizations.of(context)!.accept),
    );
  }
}
