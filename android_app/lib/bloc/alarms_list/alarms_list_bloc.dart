import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:led_alarm/model/alarm.dart';
import 'package:led_alarm/service/alarm_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:meta/meta.dart';
import 'dart:async';


import 'package:shared_preferences/shared_preferences.dart';

part 'alarms_list_event.dart';

part 'alarms_list_state.dart';

class AlarmsListBloc extends Bloc<AlarmsListEvent, AlarmsListState> with ChangeNotifier {
  final AlarmService alarmService = locator.get<AlarmService>();

  AlarmsListBloc() : super(AlarmsListState());

  @override
  Stream<AlarmsListState> mapEventToState(AlarmsListEvent event) async* {
    // late final String? uid;
    // SharedPreferences.getInstance().then((SharedPreferences prefs) async {
    //   uid = prefs.getString('uid');
    // });
    if (event.runtimeType == GetAlarmsListEvent) {
      print("GET ALARMS");
      List<Alarm> alarms = await _fetchAlarmsList();
      yield AlarmsListState(alarms: alarms);
    } else if (event.runtimeType == AddNewAlarmEvent) {
      print("ADD ALARM");
      List<Alarm> alarms = await _addAlarm(event as AddNewAlarmEvent);
      yield AlarmsListState(alarms: alarms);
    } else if (event.runtimeType == EditAlarmEvent) {
      print("EDIT ALARM");
      List<Alarm> alarms = await _editAlarm(event as EditAlarmEvent);
      yield AlarmsListState(alarms: alarms);
    } else if (event.runtimeType == AddToDeletionAlarmsListEvent) {
      List<Alarm> newList = _addAlarmToDeletionList(event as AddToDeletionAlarmsListEvent);
      yield state.copyWith(alarmsToDelete: newList);
    } else if (event.runtimeType == DeleteAlarmsListEvent) {
      print("DELETE ALARMS");
      await _deleteAlarms(event as DeleteAlarmsListEvent);
      List<Alarm> alarms = await _updateAlarmsList();
      yield AlarmsListState(alarms: alarms);
    }
  }

  Future<List<Alarm>> _fetchAlarmsList() async {
    return (state.alarms == null) ? await _updateAlarmsList() : state.alarms!;
  }

  Future<List<Alarm>> _updateAlarmsList() async {
    return await alarmService.getAlarms();
  }

  Future<List<Alarm>> _addAlarm(AddNewAlarmEvent event) {
    return alarmService.addAlarm(event.alarm);
  }

  Future<List<Alarm>> _editAlarm(EditAlarmEvent event) async {
    return await alarmService.editAlarm(event.alarm);
  }

  List<Alarm> _addAlarmToDeletionList(AddToDeletionAlarmsListEvent event)  {
    Alarm alarmToDelete = event.alarm;
    List<Alarm> list = state.alarmsToDelete ?? <Alarm>[];
    list.contains(alarmToDelete) ? list.remove(alarmToDelete) : list.add(alarmToDelete);
    return List<Alarm>.from(list);
  }

  Future<void> _deleteAlarms(DeleteAlarmsListEvent event) async {
    for (Alarm alarm in state.alarmsToDelete ?? []) {
      await alarmService.deleteAlarm(alarm);
    }
  }
}
