import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:led_alarm/bloc/alarms_list/alarms_list_bloc.dart';
import 'package:led_alarm/controller/locator.dart';
import 'package:led_alarm/model/alarm.dart';
import 'package:led_alarm/service/alarm_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAlarmService extends Mock implements AlarmService {}

final MockAlarmService mockAlarmService = MockAlarmService();

class FakeAlarm extends Fake implements Alarm {}

Alarm knownAlarm = Alarm.random();
Alarm editedKnownAlarm = knownAlarm.copyWith(color: knownAlarm.color.withAlpha(100));

List<Alarm> dummyAlarms = List.generate(2, (_) => Alarm.random());
List<Alarm> dummyAlarmsAfterAddition = List.from(List.from(dummyAlarms)..add(knownAlarm));
List<Alarm> dummyAlarmsAfterEdition = List.from(_editKnowAlarm(dummyAlarmsAfterAddition, editedKnownAlarm));
List<Alarm> dummyAlarmsAfterDeletion = List.from(List.from(dummyAlarms)..remove(knownAlarm));

List<Alarm> _editKnowAlarm(List<Alarm> alarms, Alarm alarm){
  int index = alarms.indexWhere((element) => element.id == alarm.id);
  if (alarms.isNotEmpty) alarms.removeWhere((element) => element.id == alarm.id);
  alarms.insert(index, alarm);
  return alarms;
}

void main() {
  locator.allowReassignment = true;
  setUp(() {
    registerFallbackValue(FakeAlarm());
    when(() => mockAlarmService.getAlarms()).thenAnswer((_) => Future.value(dummyAlarms));
    when(() => mockAlarmService.addAlarm(any())).thenAnswer((_) => Future.value(dummyAlarmsAfterAddition));
    when(() => mockAlarmService.editAlarm(any())).thenAnswer((_) => Future.value(dummyAlarmsAfterEdition));
    locator.registerLazySingleton<AlarmService>(() => mockAlarmService);
  });

  blocTest('should return alarms',
      build: () => AlarmsListBloc(),
      act: (AlarmsListBloc bloc) {
        bloc.add(GetAlarmsListEvent());
        return;
      },
      expect: () => [AlarmsListState(alarms: dummyAlarms)]);

  blocTest('should return updated alarms after addition',
      build: () => AlarmsListBloc(),
      act: (AlarmsListBloc bloc) {
        bloc.add(GetAlarmsListEvent());
        bloc.add(AddNewAlarmEvent(knownAlarm));
        return;
      },
      expect: () => [
            AlarmsListState(alarms: dummyAlarms),
            AlarmsListState(alarms: dummyAlarms..add(knownAlarm)),
          ]);

  blocTest('should return updated alarms after edition',
      build: () => AlarmsListBloc(),
      act: (AlarmsListBloc bloc) {
        bloc.add(GetAlarmsListEvent());

        Alarm editedAlarm = dummyAlarms.last.copyWith(color: Color(dummyAlarms.last.color.withAlpha(100).value));

        bloc.add(EditAlarmEvent(editedAlarm));
        return;
      },
      expect: () => [
            AlarmsListState(alarms: dummyAlarms..add(knownAlarm)),
            AlarmsListState(alarms: dummyAlarmsAfterEdition),
          ]);

  blocTest('should return alarms after deletion',
      build: () => AlarmsListBloc(),
      act: (AlarmsListBloc bloc) {
        bloc.add(GetAlarmsListEvent());

        bloc.add(AddToDeletionAlarmsListEvent(knownAlarm));

        return;
      },
      expect: () => [
        AlarmsListState(alarms: dummyAlarms..add(knownAlarm)),
        AlarmsListState(alarms: dummyAlarms, alarmsToDelete: [knownAlarm]),
      ]);
}
