import 'package:flutter/material.dart';

class BackgroundDecoration extends StatelessWidget {
  final Widget child;

  const BackgroundDecoration({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).primaryColor.withAlpha(185),Theme.of(context).primaryColor],
          ),
        ),
        child: child);
  }
}
