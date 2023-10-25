import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:led_alarm/bloc/alarms_list/alarms_list_bloc.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/widget/rounded_triangle.dart';
import 'package:led_alarm/view/add_alarm_page/add_alarm_page.dart';

class AlarmCard extends StatefulWidget {
  final AlarmsListBloc alarmsListBloc;
  final Alarm alarm;
  final ToggleableBoolean isEditingListMode;

  AlarmCard({
    Key? key,
    required this.alarmsListBloc,
    required this.alarm,
    required this.isEditingListMode,
  }) : super(key: key);
  // final FirebaseCommunicationService _service = locator.get<FirebaseCommunicationService>();
  //final AlarmService _alarmService = locator.get<AlarmService>();

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  @override
  Widget build(BuildContext context) {
    return _createAlarmCard();
  }

  Widget _createAlarmCard() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: GestureDetector(
        onLongPress: toggleEditingMode,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Stack(
            children: [
              _createColorDecoration(),
              _createListTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createColorDecoration() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: RoundedTriangle(color: widget.alarm.color),
      ),
    );
  }

  Widget _createListTile() {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: _createTitle(widget.alarm),
            subtitle: _createSubTitle(widget.alarm),
            onTap: _onTapCard,
            trailing: _createTrailing(),
          ),
        ],
      ),
    );
  }

  void _onTapCard() {
    widget.isEditingListMode.value
        ? checkboxOnChanged(false)
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAlarmPage(alarmsListBloc: widget.alarmsListBloc, alarm: widget.alarm),
            ),
          );
  }

  Widget _createTrailing() {
    return Observer(
      builder: (_) => AnimatedSwitcher(
        child: widget.isEditingListMode.value
            ? Padding(
                padding: const EdgeInsets.only(right: 11),
                child: Checkbox(
                    value: widget.alarmsListBloc.state.alarmsToDelete?.contains(widget.alarm) ?? false,
                    onChanged: checkboxOnChanged),
              )
            : Switch(
                onChanged: switchOnChanged,
                value: widget.alarm.state,
                activeColor: Theme.of(context).colorScheme.secondary),
        duration: Duration(milliseconds: 400),
      ),
    );
  }

  void switchOnChanged(bool? value) {
    widget.alarmsListBloc.add(EditAlarmEvent(widget.alarm.copyWith(state: value)));
  }

  void checkboxOnChanged(bool? value) {
    setState(
      () {
        widget.alarmsListBloc.add(AddToDeletionAlarmsListEvent(widget.alarm));
      },
    );
  }

  void toggleEditingMode() {
    setState(() {
      widget.isEditingListMode.toggle();
    });
  }


  Widget _createTitle(Alarm alarm) {
    return Text(
      alarm.time.format(context),
      style: TextStyle(fontSize: 22),
    );
  }

  Widget _createSubTitle(Alarm alarm) {
    return Text(alarm.getFormattedListDaysShort(context), overflow: TextOverflow.ellipsis);
  }
}
