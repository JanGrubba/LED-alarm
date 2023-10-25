import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AbstractFormScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Widget buildLightbulbImageContainer(BuildContext context){
    return Container(
        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.18, MediaQuery.of(context).size.height*0.05, 0, 0),
        child:Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 10.0),
          child: Container(
            //color: Colors.green,
            height: 200,
            width: 200,
            child: Image.asset("assets/images/smart-bulb.png"),
          ),
        )
    );
  }

  Widget buildTextFieldForm(TextEditingController controller,String hint){
    return  Padding(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        controller: controller,
        decoration:  InputDecoration(
          labelText: "Enter " + hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter ' + hint;
          }
          return null;
        },
      ),
    );
  }

}