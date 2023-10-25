import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/view/home_screen/home.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Smart Alarm",
        description: "Witaj w aplikcji Smart Alarm!",
        pathImage: "assets/smart-bulb.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "Akcje",
        description: "Dodaj akcje które będa autmatycznie sterować twoim oświetleniem",
        pathImage: "assets/calendar.png",
        backgroundColor: Color(0xff83d564),
      ),
    );
    slides.add(
      new Slide(
        title: "Alarmy",
        description: "A może chcesz aby światło budziło się razem z twoim budzikiem?",
        backgroundColor: Color(0xff618ce5),
        pathImage: "assets/notification.png",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      hideStatusBar: false,
      renderSkipBtn: this.renderSkipBtn(),
      renderNextBtn: this.renderNextBtn(),
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorActiveDot: Color(0xffffffff),
    );
  }

  void onDonePress() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(title: "LED Alarm"),
        ),
        (Route<dynamic> route) => false);
  }

  Widget renderNextBtn() {
    return Text(
      AppLocalizations.of(context)!.next,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget renderDoneBtn() {
    return Text(
      AppLocalizations.of(context)!.finish,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget renderSkipBtn() {
    return Text(
      AppLocalizations.of(context)!.skip,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
