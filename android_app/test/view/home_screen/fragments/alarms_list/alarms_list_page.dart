import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:led_alarm/bloc/alarms_list/alarms_list_bloc.dart';
import 'package:led_alarm/controller/locator.dart';
import 'package:led_alarm/model/alarm.dart';
import 'package:led_alarm/service/alarm_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/util_functions_for_test.dart';
import 'package:led_alarm/view/home_screen/fragment/alarms_list/alarms_list_page.dart';
import 'package:mocktail/mocktail.dart';

final AlarmsListBloc dummyAlarmsListBloc = AlarmsListBloc();

class MockAlarmService extends Mock implements AlarmService {}

final MockAlarmService mockAlarmService = MockAlarmService();

class FakeAlarm extends Fake implements Alarm {}

Alarm knownAlarm = Alarm.random();
Alarm editedKnownAlarm = knownAlarm.copyWith(color: knownAlarm.color.withAlpha(100));

List<Alarm> dummyAlarms = List.generate(2, (_) => Alarm.random());
List<Alarm> dummyAlarmsAfterAddition = List.from(List.from(dummyAlarms)..add(knownAlarm));
List<Alarm> dummyAlarmsAfterEdition = List.from(_editKnowAlarm(dummyAlarmsAfterAddition, editedKnownAlarm));
List<Alarm> dummyAlarmsAfterDeletion = List.from(List.from(dummyAlarms)..remove(knownAlarm));

List<Alarm> _editKnowAlarm(List<Alarm> alarms, Alarm alarm) {
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

  testWidgets('Should correctly render content and correctly react to long press on Card', (WidgetTester tester) async {
    await tester.pumpWidget(await UtilsTesting().makeTestableWidget(child: AlarmsListPage()));

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.longPress(find.byType(Card).first);
    await tester.pumpAndSettle(Duration(seconds: 5));

    expect(find.byIcon(Icons.delete_outlined), findsOneWidget);

    await tester.longPress(find.byType(Card).first);
    await tester.pumpAndSettle(Duration(seconds: 5));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
