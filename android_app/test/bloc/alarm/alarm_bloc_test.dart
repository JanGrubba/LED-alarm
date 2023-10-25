import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:led_alarm/bloc/alarm/alarm_bloc.dart';
import 'package:led_alarm/model/alarm.dart';
import 'package:led_alarm/service/alarm_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAlarmService extends Mock implements AlarmService {}

final MockAlarmService mockAlarmService = MockAlarmService();

class FakeAlarm extends Fake implements Alarm {}

Alarm knownAlarm = Alarm.random();
Alarm editedKnownAlarm = knownAlarm.copyWith(color: knownAlarm.color.withAlpha(100));

void main() {
  blocTest('should return Alarm',
      build: () => AlarmBloc(null),
      act: (AlarmBloc bloc) {
        bloc.add(AlarmEventBuilder(knownAlarm));
        bloc.add(AlarmEventBuilder(editedKnownAlarm));
        return;
      },
      expect: () => [
            AlarmStateBuilder(alarm: knownAlarm),
            AlarmStateBuilder(alarm: editedKnownAlarm),
          ]);
}
