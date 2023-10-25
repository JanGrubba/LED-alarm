import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:led_alarm/service/firebase_communication_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/observable_int.dart';

class ActionSelectCard extends StatefulWidget {
  final ObservableInt toggleIndexSelected;
  final Intro? homePageIntro;

  const ActionSelectCard({Key? key, required this.toggleIndexSelected, this.homePageIntro}) : super(key: key);

  @override
  _ActionSelectCardState createState() => _ActionSelectCardState();
}

class _ActionSelectCardState extends State<ActionSelectCard> {
  final SecureStorageController _secureStorageController = locator.get<SecureStorageController>();
  final FirebaseCommunicationService _firebaseCommunicationService = locator.get<FirebaseCommunicationService>();

  /// FIXME zmianić:
  /// usunąć z konstuktora
  /// dodać w funcji onSelect wywołanie do serwera
  // int toggleIndexSelected = LightingState.Off;

  @override
  Widget build(BuildContext context) {
    /// FIXME funkcja któa będzie przygotowywać stronę do przeprowadzenia samouczka
    // _checkIsIntroModeAndShowColorCard();

    return Container(
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
                _buildTrailing(),
                _buildToggleTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Text(
        AppLocalizations.of(context)!.action + ':',
        style: TextStyle(fontSize: 17),
      ),
    );
  }

  Widget _buildToggleTab() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: FlutterToggleTab(
        key: widget.homePageIntro?.keys[5],
        width: 60,
        borderRadius: 30,
        height: 40,
        selectedIndex: widget.toggleIndexSelected.value,
        selectedTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        unSelectedTextStyle: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
        labels: [
          AppLocalizations.of(context)!.turnOff,
          AppLocalizations.of(context)!.turnOn,
          AppLocalizations.of(context)!.auto
        ],
        selectedLabelIndex: _onSelect,
      ),
    );
  }

  Future<void> _onSelect(int index) async {
    setState(
      () {
        widget.toggleIndexSelected.set(index);
        print(index.toString());
        _firebaseCommunicationService.changeDeviceWorkingMode(index);
      },
    );
    await _secureStorageController.writeSecureData(SecureStorageKeys.TOGGLE_INDEX_SELECTED, index.toString());
    // _checkIsColorCardVisible(index);
  }

    /// FIXME funkcja któa będzie przygotowywać stronę do przeprowadzenia samouczka
  // void _checkIsIntroModeAndShowColorCard() {
  //   WidgetsBinding.instance!.addPostFrameCallback(
  //     (_) async {
  //       if (widget.homePageIntro != null) widget.toggleIndexSelected.set(LightingState.On);
  //     },
  //   );
  // }
}
