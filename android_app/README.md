# LED alarm app
Android app allowing use and remote control of custom LED lamp.

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info

This project is created as a part of a process of obtaining a BEng degree (Bachelor of Engineering). It consist of Android application created using Flutter framework allowing the use and remote control of custom designed and built LED lamp. Google Firebase is chosen as an intermediary medium for communication between an app and the controller (code for controller stored in another directory).

## Technologies

Project is created with:
* Flutter - version 2.5
* Dart - version 2.14
* Flutter plugins (plugins and their versions listed in [pubspec.yaml](pubspec.yaml))

## Setup

For android app it is recommended to upload it to your device using [Android Studio](https://developer.android.com/studio).

To properly run Android App it is required of user to copy their individual `google-services.json` file generated while setting up a Firebase database and paste it in following location: [android/app/src](android/app/src)
