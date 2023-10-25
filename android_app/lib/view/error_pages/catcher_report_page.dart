import 'package:catcher/catcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:led_alarm/util/common_package.dart';

class CatcherReportPage extends PageReportMode {
  @override
  void requestAction(Report report, BuildContext? context) {
    if (context != null) {
      _navigateToPageWidget(report, context);
    }
  }

  void _navigateToPageWidget(Report report, BuildContext context) async {
    await Future<void>.delayed(Duration.zero);
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ErrorPageWidget(this, report),
      ),
    );
  }
}

class ErrorPageWidget extends StatefulWidget {
  final PageReportMode pageReportMode;
  final Report report;

  const ErrorPageWidget(
    this.pageReportMode,
    this.report, {
    Key? key,
  }) : super(key: key);

  @override
  ErrorPageWidgetState createState() {
    return ErrorPageWidgetState();
  }
}

class ErrorPageWidgetState extends State<ErrorPageWidget> {
  @override
  Widget build(BuildContext context) {
    print("test");
    return WillPopScope(
      onWillPop: () async {
        widget.pageReportMode.onActionRejected(widget.report);
        return true;
      },
      child: Builder(
        builder: (context) => _buildMaterialPage(),
      ),
    );
  }

  Widget _buildMaterialPage() {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.pageReportMode.localizationOptions.pageReportModeDescription,
                style: _getTextStyle(15),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 13),
                    blurRadius: 25,
                    color: Color(0xFFA4EA74).withOpacity(0.25),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    onPressed: () => _onCancelClicked(),
                    child: Text(widget.pageReportMode.localizationOptions.pageReportModeCancel),
                  ),
                  MaterialButton(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    onPressed: () => _onAcceptClicked(),
                    child: Text(widget.pageReportMode.localizationOptions.pageReportModeAccept),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _getTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      decoration: TextDecoration.none,
    );
  }

  void _onAcceptClicked() {
    widget.pageReportMode.onActionConfirmed(widget.report);
    _closePage();
  }

  void _onCancelClicked() {
    widget.pageReportMode.onActionRejected(widget.report);
    _closePage();
  }

  void _closePage() {
    Navigator.of(context).pop();
  }
}
