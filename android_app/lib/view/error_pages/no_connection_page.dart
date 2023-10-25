import 'package:flutter/material.dart';
import 'package:led_alarm/util/common_package.dart';

class NoConnectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/no_Connection.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 190,
            left: 45,
            right: 40,
            child: Text(
              AppLocalizations.of(context)!.noConnection,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 45,
            child:  MaterialButton(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              onPressed: () {},
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          )
        ],
      ),
    );
  }
}
