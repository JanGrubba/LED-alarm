import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:led_alarm/view/login_screen/abstract_form_screen.dart';

class EmailLogIn extends AbstractFormScreen{

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        //margin: MediaQuery.of(context).size.height * 0.05,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child:Stack(
            children: [
              Positioned( //positioned helps to position widget wherever we want.
                  child: buildLightbulbImageContainer(context)
              ),
              Positioned(
                  child:SingleChildScrollView(
                    child: _buildRegistrationForm(context)
                  ),
              )
            ],
          )
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context){
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.02,MediaQuery.of(context).size.height*0.3, MediaQuery.of(context).size.width*0.02, 0),
        height:  MediaQuery.of(context).size.height * 0.36,
        width: MediaQuery.of(context).size.width * 0.96,
        child:Column(
          children: [
            buildTextFieldForm(emailController,"Email"),
            buildTextFieldForm(passwordController,"Password"),
            _buildSubmitLoginButton(context),
          ],
        ),
      )
    );
  }

  Widget _buildSubmitLoginButton(BuildContext context){
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          logInToFb(context);
        }
      },
      child: Text('Submit'),
    );
  }

  void logInToFb(BuildContext context) {
    // firebaseAuth
    //     .signInWithEmailAndPassword(
    //     email: emailController.text, password: passwordController.text)
    //     .then((result) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => MyHomePage(title: 'LED Alarm',)),
    //     // MaterialPageRoute(builder: (context) => Home(uid: result.user!.uid)),
    //   );
    // }).catchError((err) {
    //   print(err.message);
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text("Error"),
    //           content: Text(err.message),
    //           actions: [
    //             TextButton(
    //               child: Text("Ok"),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             )
    //           ],
    //         );
    //       });
    // });
  }

}