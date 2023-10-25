import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:led_alarm/bloc/alarms_list/alarms_list_bloc.dart';
import 'package:led_alarm/bloc/events_list/alarms_list_bloc.dart';
import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:led_alarm/model/state_enum.dart';
import 'package:led_alarm/service/firebase_communication_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/observable_int.dart';
import 'package:led_alarm/util/widget/accept_button.dart';

class ColorInfoSelectCard extends StatefulWidget {
  final ObservableInt toggleIndexSelected;
  final Intro? homePageIntro;

  const ColorInfoSelectCard({Key? key, required this.homePageIntro, required this.toggleIndexSelected})
      : super(key: key);

  @override
  _ColorInfoSelectCardState createState() => _ColorInfoSelectCardState();
}

class _ColorInfoSelectCardState extends State<ColorInfoSelectCard> {
  late Color currentColor = Colors.greenAccent;
  final FirebaseCommunicationService _firebaseCommunicationService = locator.get<FirebaseCommunicationService>();
  final SecureStorageController _secureStorageController = locator.get<SecureStorageController>();

  @override
  void initState(){
    _postInit();
    super.initState();
  }

  void _postInit() {

    WidgetsBinding.instance!.addPostFrameCallback(
          (_) async {
            // checkColor().then((value) {
            //   setState(() {});
            // });
            checkColor();
      },
    );
  }

  Future<void> checkColor() async {
    String? color = await _secureStorageController.readSecureData(SecureStorageKeys.SELECTED_COLOR);
    if(color == null){
      currentColor = await _firebaseCommunicationService.getSavedColor();

    }
    else{
      // setState(() {
        currentColor = Color(int.parse(color));
      // });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => AnimatedOpacity(
        opacity: widget.toggleIndexSelected.value != LightingState.Off ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 1000),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
          height: _getHeight(),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLeading(),
                    _buildTrailing(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getHeight() {
    if (widget.toggleIndexSelected.value == LightingState.Off)
      return 20.0;
    else if (widget.toggleIndexSelected.value == LightingState.Auto)
      return 130.0;
    else
      return 110.0;
  }

  Widget _buildLeading() {
    if (widget.toggleIndexSelected.value == LightingState.Off) return SizedBox.shrink();
    return widget.toggleIndexSelected.value == LightingState.On ? _buildLeadingColor() : _buildLeadingInfo();
  }

  Widget _buildLeadingColor() {
    return Padding(
      key: ValueKey<int>(0),
      padding: const EdgeInsets.only(left: 30),
      child: Text(AppLocalizations.of(context)!.color, style: TextStyle(fontSize: 17)),
    );
  }

  Widget _buildLeadingInfo() {
    return Padding(
      key: ValueKey<int>(1),
      padding: const EdgeInsets.only(left: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.numberOfActiveAlarms,

              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              AppLocalizations.of(context)!.numberOfActiveEvents,
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    if (widget.toggleIndexSelected.value == LightingState.Off) return SizedBox.shrink();
    return widget.toggleIndexSelected.value == LightingState.On ? _buildButton() : _buildAlarmsCountInfo();
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
        key: widget.homePageIntro?.keys[6],
        onPressed: _onPress,
        child: null,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(CircleBorder()),
          elevation: MaterialStateProperty.all(5),
          backgroundColor: MaterialStateProperty.all(currentColor),
        ),
      ),
    );
  }

  Widget _buildAlarmsCountInfo() {
    return BlocBuilder<AlarmsListBloc, AlarmsListState>(
      builder: (_, alarmsState) {
        return BlocBuilder<EventsListBloc, EventsListState>(
          builder: (_, eventsState) {
            return Padding(
              padding: const EdgeInsets.only(right: 35),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      alarmsState.alarms?.where((element) => element.state == true).length.toString() ?? '0',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      eventsState.events?.where((element) => element.state == true).length.toString() ?? '0',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onPress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                child: SlidePicker(
                  pickerColor: currentColor,
                  onColorChanged: changeColor,
                  paletteType: PaletteType.rgb,
                  enableAlpha: false,
                  displayThumbColor: true,
                  showLabel: true,
                  showIndicator: true,
                  indicatorBorderRadius: const BorderRadius.vertical(
                    top: const Radius.circular(10.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AcceptButton(
                    onPressed: () => {
                      _firebaseCommunicationService.createDevicePlainColor(currentColor),
                      Navigator.pop(context)
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> changeColor(Color color) async {
    await _secureStorageController.writeSecureData(SecureStorageKeys.SELECTED_COLOR, color.value.toString());
    setState(() => currentColor = color);
  }
}
