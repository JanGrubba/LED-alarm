# LED alarm
Android app and ESP8266 code allowing use and remote control of custom LED lamp.

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info

This project is created as a part of a process of obtaining a BEng degree (Bachelor of Engineering). It consist of Android application created using Flutter framework allowing the use and remote control of custom designed and built LED lamp. Controls of lamp itself are being handled by code in C operating on ESP8266 controller. Google Firebase is chosen as an intermediary medium for communication between an app and the controller.

## Technologies

Project is created with:
* Flutter - version 2.5
* Dart - version 2.14
* C++ - standard C17
* Flutter plugins (plugins and their versions listed in [pubspec.yaml](android_app/pubspec.yaml))
* C++ libraries for ESP8266 (listed in [esp_code.ino](esp_code.ino))

## Setup

To run this project install code from [esp_code.ino](esp_code.ino) to ESP8266 board using [Arduino IDE](https://www.arduino.cc/en/software). For android app it is recommended to upload it to your device using [Android Studio](https://developer.android.com/studio).

Code for ESP8266 requires filling marked blanks with user's individual Firebase access data in [esp_code.ino](esp_code.ino).

To properly run Android App it is required of user to copy their individual `google-services.json` file generated while setting up a Firebase database and paste it in following location: [android_app/android/app/src](android_app/android/app/src)

