import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:led_alarm/model/state_enum.dart';
import 'package:led_alarm/style/text_theme.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/observable_int.dart';

class StateCard extends StatefulWidget {
  /// FIXME zmianić aby zmienna posiadała dane pobrane z serwera
  /// i usunąć zależność od pozostałych kart
  final ObservableInt toggleIndexSelected;
  final Intro? homePageIntro;

  const StateCard({Key? key, required this.homePageIntro, required this.toggleIndexSelected}) : super(key: key);

  @override
  _StateCardState createState() => _StateCardState();
}

class _StateCardState extends State<StateCard> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
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
                  _buildStatusChip(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.state,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 115),
              child: Container(
                child: Text(
                AppLocalizations.of(context)!.readFromTheServer,
                style: MyTextStyle.Body2TextStyle.copyWith(fontSize: 14),
                overflow: TextOverflow.clip,
                maxLines: 2,
              )
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Chip(
        key: widget.homePageIntro?.keys[2],
        labelPadding: const EdgeInsets.only(left: 12),
        avatar: ConditionalSwitch.single<int>(
          context: context,
          valueBuilder: (_) => widget.toggleIndexSelected.value,
          caseBuilders: {
            LightingState.Off: (_) => _buildStateOffChip(),
            LightingState.On: (_) => _buildStateOnChip(),
            LightingState.Auto: (_) => _buildStateAutoChip(),
          },
          fallbackBuilder: (_) => SizedBox.shrink(),
        ),
        label: Text(
          _getChipText(widget.toggleIndexSelected.value),
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 3.0,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Widget _buildStateOffChip() {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.nights_stay_outlined,
        size: 19,
      ),
    );
  }

  Widget _buildStateOnChip() {
    return CircleAvatar(
      key: widget.homePageIntro?.keys[3],

      /// FIXME trzeba dodać AktualnyStanOświetlenia
      ///  i potem pobrać aktulny kolor i wstawić go tutaj
      //     backgroundColor: currentColor,
      child: Icon(
        Icons.wb_sunny_outlined,
        size: 17,

        /// FIXME tak jak powyżej
        // color: MyTextStyle.getMatchingColorByBackgroundColor(
        //   backgroundColor: currentColor,
        //   darkColor: Colors.black54,
        // ),
      ),
    );
  }

  Widget _buildStateAutoChip() {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.auto_awesome,
        size: 19,
      ),
    );
  }

  String _getChipText(int toggleIndexSelected) {
    switch (toggleIndexSelected) {
      case LightingState.Off:
        return AppLocalizations.of(context)!.off;
      case LightingState.On:
        return AppLocalizations.of(context)!.on;
      case LightingState.Auto:
        return AppLocalizations.of(context)!.auto;
      default:
        return "";
    }
  }
}
