import 'dart:ui';

import 'package:flutter/material.dart';

import '../firebase_communication_service.dart';

class MockCommunicationService  extends FirebaseCommunicationService{
  
  @override
  void changeDeviceWorkingMode(int index) {
    // TODO: implement changeDeviceWorkingMode
  }

  @override
  void createDevicePlainColor(Color color) {
    // TODO: implement createDevicePlainColor
  }

  @override
  Future<Color> getSavedColor() {
    return Future.value(Colors.greenAccent);
  }

  @override
  Future<int> isDeviceWorking() {
    // TODO: implement isDeviceWorking
    return Future.value(1);
  }

  @override
  void setEventsModificationDate() {
    // TODO: implement setEventsModificationDate
  }
  
}