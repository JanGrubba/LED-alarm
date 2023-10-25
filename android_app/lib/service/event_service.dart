import 'dart:collection';
import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:led_alarm/model/event.dart' as event;
import 'package:shared_preferences/shared_preferences.dart';

abstract class EventService {
  Future<List<event.Event>> getEvents();

  Future<List<event.Event>> addEvent(event.Event event);

  Future<List<event.Event>> editEvent(event.Event event);

  Future<void> deleteEvent(event.Event event);

  int compareEvents(event.Event a, event.Event b) {
    int sumA = a.hour * 60 + a.minute;
    int sumB = b.hour * 60 + b.minute;
    return sumA.compareTo(sumB);
  }
  
  void uploadEventToSpecificUsersData(String uid, event.Event alarm);

  void updateSingleEvent(String uid,event.Event alarm);

  Future<List<event.Event>?> getAllEventsFromUser(String uid);

  void deleteSingleEvent(String uid,event.Event alarm);

  void setEventsModificationDate();
}

class ImplEventService extends EventService {
  List<event.Event> events = List.generate(faker.randomGenerator.integer(5) + 2, (index) => event.Event.random());
  String ESP_GUID = "9egjSaKea7Vd0HQJBC7pQfGsMd92";

  Future<String> _getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uid = sharedPreferences.getString('uid').toString();
    return uid;
  }

  @override
  Future<List<event.Event>> getEvents() async {
    List<event.Event>? listOfEvents = await getAllEventsFromUser(await _getUid());
    return listOfEvents!..sort(compareEvents);
  }

  @override
  Future<List<event.Event>> addEvent(event.Event event) async {
    events = (await getAllEventsFromUser(await _getUid()))!;
    uploadEventToSpecificUsersData(await _getUid(), event);
    events.add(event);
    return events..sort(compareEvents);
  }

  @override
  Future<List<event.Event>> editEvent(event.Event event) async {
    updateSingleEvent(await _getUid(), event);
    events = await getEvents();
    return events..sort(compareEvents);
  }

  @override
  Future<void> deleteEvent(event.Event event) async {
    deleteSingleEvent(await _getUid(),event);
    events.remove(event);
    events = await getEvents();
  }

  @override
  void deleteSingleEvent(String uid, event.Event alarm) {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    reference.child("Users Data").child(uid).child("events").child(alarm.id).remove();
    reference.child("Users Data").child(uid).child("eventsIDs").child(alarm.id).remove();
    setEventsModificationDate();

  }

  @override
  Future<List<event.Event>?> getAllEventsFromUser(String uid) async {
    final _db = FirebaseDatabase().reference();
    List<event.Event>? returnedList = [];
    DataSnapshot result = await _db.child('Users Data/$uid/events').once();
    final LinkedHashMap? value = result.value;
    if(value != null){
      var values = value.values;
      values.forEach((element) {
        Map<String, dynamic> json = Map<String, dynamic>.from(element);
        event.Event eventFromJson = event.Event.fromJson(json);
        returnedList.add(eventFromJson);
      });
    }
    return returnedList;
  }

  @override
  void updateSingleEvent(String uid, event.Event alarm) {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    reference.child("Users Data").child(uid).child("events").child(alarm.id).update(alarm.toJson());
    if (alarm.state == false){
      reference.child("Users Data").child(uid).child("eventsIDs").child(alarm.id).remove();
    }
    if (alarm.state == true){
      reference.child("Users Data").child(uid).child("eventsIDs").child(alarm.id).set(true);
    }
    setEventsModificationDate();


  }

  @override
  void uploadEventToSpecificUsersData(String uid, event.Event alarm) {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    reference.child("Users Data").child(uid).child("events").child(alarm.id).set(alarm.toJson());
    reference.child("Users Data").child(uid).child("eventsIDs").child(alarm.id).set(true);
    setEventsModificationDate();

  }

  @override
  void setEventsModificationDate() {
    DatabaseReference reference;
    reference = FirebaseDatabase().reference();
    int time = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch).millisecondsSinceEpoch % 518400000;
    reference.child("Users Data").child(ESP_GUID).child("lastEventsModification").set((time));
  }
}
