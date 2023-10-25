import 'package:led_alarm/bloc/alarm/alarm_bloc.dart';
import 'package:led_alarm/bloc/alarms_list/alarms_list_bloc.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/view/add_alarm_page/widget/alarm_mode_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/color_picker_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/spinner_time_picker_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/week_buttons_row_tile.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddAlarmPage extends StatefulWidget {
  final Alarm? alarm;
  final AlarmsListBloc alarmsListBloc;

  const AddAlarmPage({Key? key, required this.alarmsListBloc, this.alarm}) : super(key: key);

  @override
  _AddAlarmPageState createState() => _AddAlarmPageState(alarm);
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  final Alarm? alarm;
  final AlarmBloc bloc;

  _AddAlarmPageState(this.alarm) : this.bloc = AlarmBloc(alarm);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmBloc, AlarmState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: _createAppBarTitle(),
            backgroundColor: Theme.of(context).primaryColor,
            leading: _createAppBarLeading(),
            actions: _createAppBarActions(),
          ),
          body: Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: [
                  _buildSpaceBetween(),
                  _buildSpinnerTimePickerTile(),
                  _buildSpaceBetween(),
                  _buildWeekButtonsTile(),
                  _buildSpaceBetween(),
                  Divider(indent: 30, endIndent: 30, color: Colors.white38),
                  _buildColorPickerTile(),
                  Divider(indent: 30, endIndent: 30, color: Colors.white38),
                  _buildAlarmModeTile(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createAppBarTitle() {
    int hour = bloc.state.alarm.hour;
    int minute = bloc.state.alarm.minute;

    var timeDifference = UtilDateFunction.calculateTimeDifferenceFromNow(hour: hour, minute: minute);

    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.addAlarm,
          style: MyTextStyle.getBody1TextStyleWithMatchedColor(context),
        ),
        Text(
          "Alarm za: " +
              timeDifference.hour.toString().padLeft(2, '0') +
              ':' +
              timeDifference.minute.toString().padLeft(2, '0'),
          style: MyTextStyle.getBody2TextStyleWithMatchedColor(context),
        ),
      ],
    );
  }

  Widget _createAppBarLeading() {
    return IconButton(
      iconSize: 28,
      padding: EdgeInsets.only(left: 16),
      icon: new Icon(
        Icons.close,
        color: MyTextStyle.getMatchingColorByTheme(context: context),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  List<Widget> _createAppBarActions() {
    return <Widget>[
      IconButton(
        iconSize: 28,
        padding: EdgeInsets.only(right: 16),
        icon: Icon(
          Icons.done,
          color: MyTextStyle.getMatchingColorByTheme(context: context),
        ),
        onPressed: () {
          _saveAlarm();
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: AppLocalizations.of(context)!.alarmHasBeenAdded,
            ),
            additionalTopPadding: 8,
            showOutAnimationDuration: Duration(seconds: 2),
            displayDuration: Duration(seconds: 1),
          );
          Navigator.of(context).pop();
        },
      )
    ];
  }

  void _saveAlarm() {
    Alarm alarm = bloc.state.alarm.copyWith();
    if (widget.alarm != null) {
      widget.alarmsListBloc.add(EditAlarmEvent(alarm));
    } else {
      widget.alarmsListBloc.add(AddNewAlarmEvent(alarm));
    }
  }

  Widget _buildWeekButtonsTile() {
    return WeekButtonsTile(
      onChange: (listDays) => bloc.add(
        AlarmEventBuilder(
          bloc.state.alarm.copyWith(repeatMode: AlarmRepeatMode.Own, listDays: listDays),
        ),
      ),
      initMode: bloc.state.alarm.repeatMode,
      listDays: bloc.state.alarm.listDays,
    );
  }

  Widget _buildSpinnerTimePickerTile() {
    return SpinnerTimePickerTile(
      alarm: bloc.state.alarm,
      onChangedHour: (hour) {
        bloc.add(
          AlarmEventBuilder(
            bloc.state.alarm.copyWith(hour: hour),
          ),
        );
      },
      onChangedMinute: (minute) {
        bloc.add(
          AlarmEventBuilder(
            bloc.state.alarm.copyWith(minute: minute),
          ),
        );
      },
    );
  }

  Widget _buildColorPickerTile() {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 16),
      child: ColorPickerTile(
        onPress: (chooseColor) {
          bloc.add(
            AlarmEventBuilder(
              bloc.state.alarm.copyWith(color: Color(chooseColor.value)),
            ),
          );
          Navigator.pop(context);
        },
        initColor: widget.alarm != null ? widget.alarm?.color ?? null : null,
      ),
    );
  }

  Widget _buildAlarmModeTile() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 16),
      child: AlarmModeTile<Alarm>(
        alarm: bloc.state.alarm,
        onChoose: (alarm, mode) {
          bloc.add(
            AlarmEventBuilder(
              alarm.copyWith(
                repeatMode: mode,
                listDays: _prepareWeekButtonsRow(mode),
              ),
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSpaceBetween({double height = 30}) {
    return SizedBox(
      height: height,
    );
  }

  Map<DayOfWeek, bool>? _prepareWeekButtonsRow(AlarmRepeatMode mode) {
    switch (mode) {
      case AlarmRepeatMode.Ed:
        return Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values, key: (item) => item, value: (_) => true);
      case AlarmRepeatMode.Once:
        return null;
      case AlarmRepeatMode.MtF:
        return Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values.getRange(0, 5),
            key: (item) => item, value: (_) => true)
          ..addAll(Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values.getRange(5, 7),
              key: (item) => item, value: (_) => false));
      case AlarmRepeatMode.Own:
        return null;
    }
  }
}
