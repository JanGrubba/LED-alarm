import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationService{

  Future<User?> signInWithGoogle({required BuildContext context});

  SnackBar customSnackBar({required String content});

  void signOutGoogle(BuildContext context);
}

class ImplAuthenticationService extends AuthenticationService{
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content:
              'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content:
              'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
      print(user!.uid.toString());
      prefs.setString('uid', user.uid);
      prefs.setString('photo_url', user.photoURL.toString());
      prefs.setString('name', user.displayName.toString());
      prefs.setString('email', user.email.toString());
      return user;
    }}

  @override
  SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  @override
  void signOutGoogle(BuildContext context) async{
    await _googleSignIn.signOut();
    Navigator.pushReplacementNamed(
      context,
      '/firebaseintro',
    );
    print("User Sign Out");
  }
}