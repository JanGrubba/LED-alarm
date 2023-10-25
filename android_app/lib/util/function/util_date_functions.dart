import 'package:flutter/material.dart';

class UtilDateFunction{
  static  TimeOfDay calculateTimeDifferenceFromNow({required int hour, required int minute}) {
    TimeOfDay now = TimeOfDay.now();

    var actualTime = (now.hour * 60 + now.minute) * 60;
    var selectedTime = (hour * 60 + minute) * 60;

    int difference = (selectedTime - actualTime + (actualTime > selectedTime ? 0 : 86400)) % 86400;

    return TimeOfDay(hour: difference ~/ 3600, minute: (difference % 3600) ~/ 60);
  }
}