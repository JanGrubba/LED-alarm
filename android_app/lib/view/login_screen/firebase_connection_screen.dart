import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:led_alarm/service/authentication_service.dart';
import 'package:led_alarm/service/firebase_communication_service.dart';
import 'package:led_alarm/style/app_theme.dart';
import 'package:led_alarm/util/common_package.dart';

import 'buttons/generic_button_view.dart';

class FireBaseIntroScreen extends StatelessWidget {
  final AuthenticationService _authenticationService = locator.get<AuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.04,
                      child: Align(alignment: Alignment.centerLeft, child: _buildVerticalLabel(context)),
                    ),
                    Positioned(
                      child: Align(alignment: Alignment.center, child: _buildGifLogo()),
                    ),
                  ],
                )),
              ],
            ),
            _buildAuthenticationSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 15),
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(
          AppLocalizations.of(context)!.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildGifLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
      child: Container(
        //color: Colors.green,
        height: 200,
        width: 200,
        child: Image.asset("assets/images/lightbulb_gif_noloop.gif"),
      ),
    );
  }

  Widget _buildAuthenticationSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, top: 100, right: 50, bottom: 20),
      child: Align(
        child: Center(
          heightFactor: 1.6 ,
            child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // _buildSignUpWithEmail(context),
              // _buildSignInWithEmail(context),
              _buildSignInWithGoogle(context),
            ])
        ),
        alignment: Alignment.center,
      ),
    );
  }

  // Widget _buildSignUpWithEmail(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.all(15.0),
  //     child: GenericButton(
  //       text: "Sign up with Email",
  //       icon: Icons.person_add_alt,
  //       color: getButtonColor(context),
  //       onPressed: () {
  //         Navigator.pushNamed(
  //           context,
  //           '/email_register',
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildSignInWithGoogle(BuildContext context) {
    final SecureStorageController _secureStorageController = locator.get<SecureStorageController>();
    final FirebaseCommunicationService _firebaseCommunicationService = locator.get<FirebaseCommunicationService>();
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: GenericButton(
        image: Padding(
            padding: EdgeInsets.all(3.0),
            child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/logos/google_light.png',
                          package: 'flutter_signin_button',
                        ),
                        fit: BoxFit.fill)))),
        text: "Sign in with Google",
        //icon: Icons.arrow_forward,
        color: getButtonColor(context),
        onPressed: () async {
          User? user = await _authenticationService.signInWithGoogle(context: context);
          // int index = await _firebaseCommunicationService.isDeviceWorking();
          // await _secureStorageController.writeSecureData(SecureStorageKeys.TOGGLE_INDEX_SELECTED,index.toString());
          if (user != null) {
            Navigator.pushReplacementNamed(
              context,
              '/home',
            );
          }
        },
      ),
    );
  }

// Widget _buildSignInWithEmail(BuildContext context) {
//   return Padding(
//     padding: EdgeInsets.all(15.0),
//     child: GenericButton(
//       text: "Sign in with Email",
//       icon: Icons.arrow_forward,
//       color: getButtonColor(context),
//       onPressed: () async {
//         Navigator.pushNamed(
//           context,
//           '/email_login',
//         );
//       },
//     ),
//   );
// }
}
