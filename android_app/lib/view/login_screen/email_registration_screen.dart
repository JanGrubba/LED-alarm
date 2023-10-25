import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'abstract_form_screen.dart';
import 'package:http/http.dart' as http;

class EmailSignUp extends AbstractFormScreen {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              Positioned(
                //positioned helps to position widget wherever we want.
                child: buildLightbulbImageContainer(context),
              ),
              Positioned(
                child: SingleChildScrollView(
                    child: _buildRegistrationForm(context)),
              )
            ],
          )),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.02,
              MediaQuery.of(context).size.height * 0.3,
              MediaQuery.of(context).size.width * 0.02,
              0),
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.96,
          child: SingleChildScrollView(
              child: Column(
            children: [
              buildTextFieldForm(nameController, "Name"),
              buildTextFieldForm(emailController, "Email"),
              buildTextFieldForm(passwordController, "Password"),
              buildTextFieldForm(ageController, "Age"),
              _buildSubmitRegistrationButton(context),
            ],
          )),
        ));
  }

  Widget _buildSubmitRegistrationButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          registerToFb(context);
        }
      },
      child: Text('Submit'),
    );
  }

  void sendData() {
    http.post(
        Uri.parse(
            "https://projekt-inzynierski-2021-default-rtdb.europe-west1.firebasedatabase.app/user.json"),
        body: json.encode({'name': "Jan", 'surname': "Kowalski"}));
  }

  void registerToFb(BuildContext context) {
    // firebaseAuth
    //     .createUserWithEmailAndPassword(
    //         email: emailController.text, password: passwordController.text)
    //     .then((result) {
    //   dbRef.child(result.user!.uid).set({
    //     "email": emailController.text,
    //     "age": ageController.text,
    //     "name": nameController.text
    //   }).then((res) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => MyHomePage(
    //                 title: 'LED Alarm',
    //               )),
    //       //MaterialPageRoute(builder: (context) => Home(uid: result.user!.uid)),
    //     );
    //   });
    // }).catchError((err) {
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
