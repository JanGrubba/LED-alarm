import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:led_alarm/model/alarm.dart';

abstract class FirebaseCommunicationService{

  void changeDeviceWorkingMode(int index);

  Future<int> isDeviceWorking();

  void createDevicePlainColor(Color color);

  Future<Color> getSavedColor();

}

class ImplFirebaseCommunicationService extends FirebaseCommunicationService{

  String ESP_GUID = "9egjSaKea7Vd0HQJBC7pQfGsMd92";

  @override
  void changeDeviceWorkingMode(int index) {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    switch (index){
      case 0:
        // reference.child("Device").child("mode").set("off");
        reference.child("Device").child(ESP_GUID).update( <String, dynamic>{'state':"off",'mode':"off"});
        reference.child("Users Data").child(ESP_GUID).update( <String, dynamic>{'state':false,'mode':"off"});
        break;
      case 1:
        // reference.child("Device").child("mode").set("on");
        reference.child("Device").child(ESP_GUID).update( <String, dynamic>{'state':"on",'mode':"on"});
        reference.child("Users Data").child(ESP_GUID).update( <String, dynamic>{'state':true,'mode':"on"});
        break;
      case 2:
        // reference.child("Device").child("mode").set("auto");
        reference.child("Device").child(ESP_GUID).update( <String, dynamic>{'state':"on",'mode':"auto"});
        reference.child("Users Data").child(ESP_GUID).update( <String, dynamic>{'state':true,'mode':"auto"});
        break;
    }
  }

  @override
  Future<int> isDeviceWorking() async {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    DataSnapshot dataSnapshot = await reference.child('Users Data/'+(ESP_GUID)+'/mode').once();
    String result = dataSnapshot.value;
    if(result == "off"){
      return 0;
    }
    else if(result == "on"){
      return 1;
    }
    else{
      return 2;
    }
  }

  Color colorFromJson(Map<Object?, dynamic> data) =>
      Color(
          data['value'] as int
      ).withAlpha(255);

  Map<String, dynamic> colorToJson(Color color) =>
      <String, dynamic>{
        'value': ((color.red * 65536) + (color.green * 256) + color.blue)
      };

  @override
  void createDevicePlainColor(Color color) {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    reference.child("Users Data").child(ESP_GUID).child("color").set(colorToJson(color));
  }

  @override
  Future<Color> getSavedColor() async {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    DataSnapshot dataSnapshot = await reference.child('Device/'+(ESP_GUID)+'/color').once();
    Color colorCode = colorFromJson(dataSnapshot.value);
    return Future.value((colorCode));
  }

}