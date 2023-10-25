import 'dart:collection';
import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:led_alarm/model/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class AlarmService {
  Future<List<Alarm>> getAlarms();

  Future<List<Alarm>> addAlarm(Alarm alarm);

  Future<List<Alarm>> editAlarm(Alarm alarm);

  Future<void> deleteAlarm(Alarm alarm);

  int compareAlarms(Alarm a, Alarm b) {
    int sumA = a.hour * 60 + a.minute;
    int sumB = b.hour * 60 + b.minute;
    return sumA.compareTo(sumB);
  }

  void uploadAlarmToSpecificUsersData(String uid, Alarm alarm);

  void updateSingleAlarm(String uid,Alarm alarm);

  Future<List<Alarm>?> getAllAlarmsFromUser(String uid);

  void deleteSingleAlarm(String uid,Alarm alarm);

  void setAlarmsModificationDate();
}

class ImplAlarmService extends AlarmService {
  List<Alarm> alarms = List.generate(faker.randomGenerator.integer(5) + 2, (index) => Alarm.random());
  String ESP_GUID = "9egjSaKea7Vd0HQJBC7pQfGsMd92";

  Future<String> _getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uid = sharedPreferences.getString('uid').toString();
    return uid;
  }

  @override
  Future<List<Alarm>> getAlarms() async {
    List<Alarm>? listOfAlarms = await getAllAlarmsFromUser(await _getUid());
    return listOfAlarms!..sort(compareAlarms);
  }

  @override
  Future<List<Alarm>> addAlarm(Alarm alarm) async {
    alarms = (await getAllAlarmsFromUser(await _getUid()))!;
    uploadAlarmToSpecificUsersData(await _getUid(), alarm);
    alarms.add(alarm);
    return alarms..sort(compareAlarms);
  }

  @override
  Future<List<Alarm>> editAlarm(Alarm alarm) async {
    updateSingleAlarm(await _getUid(), alarm);
    alarms = await getAlarms();
    return alarms..sort(compareAlarms);
  }

  @override
  Future<void> deleteAlarm(Alarm alarm ) async {
    deleteSingleAlarm(await _getUid(),alarm);
    alarms.remove(alarm);
    alarms = await getAlarms();
  }

  @override
  void uploadAlarmToSpecificUsersData(String uid, Alarm alarm ) {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    reference.child("Users Data").child(uid).child("alarms").child(alarm.id).set(alarm.toJson());
    reference.child("Users Data").child(uid).child("alarmsIDs").child(alarm.id).set(true);
    setAlarmsModificationDate();
  }



  void updateSingleAlarm(String uid,Alarm alarm){
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    reference.child("Users Data").child(uid).child("alarms").child(alarm.id).update(alarm.toJson());
    if (alarm.state == false){
      reference.child("Users Data").child(uid).child("alarmsIDs").child(alarm.id).remove();
    }
    if (alarm.state == true){
      reference.child("Users Data").child(uid).child("alarmsIDs").child(alarm.id).set(true);
    }
    setAlarmsModificationDate();
  }

  @override
  Future<List<Alarm>?> getAllAlarmsFromUser(String uid) async{
    final _db = FirebaseDatabase().reference();
    List<Alarm>? returnedList = [];
    DataSnapshot result = await _db.child('Users Data/$uid/alarms').once();
    final LinkedHashMap? value = result.value;
    if(value != null){
      var values = value.values;
      values.forEach((element) {
        Map<String, dynamic> json = Map<String, dynamic>.from(element);
        Alarm alarm = Alarm.fromJson(json);
        returnedList.add(alarm);
      });
    }
    return returnedList;
  }

  @override
  void deleteSingleAlarm(String uid, Alarm alarm) {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    reference.child("Users Data").child(uid).child("alarms").child(alarm.id).remove();
    reference.child("Users Data").child(uid).child("alarmsIDs").child(alarm.id).remove();
    setAlarmsModificationDate();
  }

  @override
  void setAlarmsModificationDate() {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    int time = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch).millisecondsSinceEpoch % 518400000;
    reference.child("Users Data").child(ESP_GUID).child("lastAlarmsModification").set((time));
  }
}
