import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:led_alarm/view/error_pages/no_connection_page.dart';
import 'package:led_alarm/view/sandbox/intro_page.dart';
import 'package:led_alarm/view/sandbox/introduction_test_page.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SandBoxPage extends StatefulWidget {
  const SandBoxPage({Key? key}) : super(key: key);

  @override
  _SandBoxPageState createState() => _SandBoxPageState();
}

class _SandBoxPageState extends State<SandBoxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("Sandbox"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            TextButton(
              onPressed: () {
                showTopSnackBar(
                  context,
                  CustomSnackBar.success(
                    message: "Yey Success",
                  ),
                  additionalTopPadding: 8,
                  showOutAnimationDuration: Duration(seconds: 2),
                );
              },
              child: Text('Show success snackbar'),
            ),
            TextButton(
              onPressed: () {
                showTopSnackBar(
                  context,
                  CustomSnackBar.error(
                    message: "Ups something goes wrong",
                  ),
                  additionalTopPadding: 8,
                  showOutAnimationDuration: Duration(seconds: 2),
                );
              },
              child: Text('Show error snackbar'),
            ),
            TextButton(
              onPressed: () {
                showTopSnackBar(
                  context,
                  CustomSnackBar.info(
                    message: "We need more info",
                  ),
                  additionalTopPadding: 8,
                  showOutAnimationDuration: Duration(seconds: 2),
                );
              },
              child: Text('Show info snackbar'),
            ),
            TextButton(
              onPressed: () {
                Catcher.sendTestException();
              },
              child: Text('Generate error'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoConnectionPage(),
                  ),
                );
              },
              child: Text('Go to no connection error page'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartPage(),
                  ),
                );
              },
              child: Text('Go to start page'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroScreen(),
                  ),
                );
              },
              child: Text('Go to intro page'),
            )
          ],
        ),
      ),
    );
  }
}
