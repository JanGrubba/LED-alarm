import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:led_alarm/bloc/alarms_list/alarms_list_bloc.dart';
import 'package:led_alarm/controller/locator.dart';
import 'package:led_alarm/model/alarm.dart';
import 'package:led_alarm/service/alarm_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/util_functions_for_test.dart';
import 'package:led_alarm/view/add_alarm_page/add_alarm_page.dart';
import 'package:led_alarm/view/add_alarm_page/widget/alarm_mode_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/color_picker_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/spinner_time_picker_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/week_buttons_row_tile.dart';
import 'package:mocktail/mocktail.dart';

final AlarmsListBloc dummyAlarmsListBloc = AlarmsListBloc();

class MockAlarmService extends Mock implements AlarmService {}

final MockAlarmService mockAlarmService = MockAlarmService();

class FakeAlarm extends Fake implements Alarm {}

void main() {
  locator.allowReassignment = true;
  setUp(() {
    registerFallbackValue(FakeAlarm());
    locator.registerLazySingleton<AlarmService>(() => mockAlarmService);
  });

  testWidgets('Should correctly render content', (WidgetTester tester) async {
    await tester.pumpWidget(await UtilsTesting().makeTestableWidget(
        child: AddAlarmPage(
      alarmsListBloc: dummyAlarmsListBloc,
    )));

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byIcon(Icons.done), findsOneWidget);
    expect(find.byType(SpinnerTimePickerTile), findsOneWidget);
    expect(find.byType(ColorPickerTile), findsOneWidget);
    expect(find.byType(WeekButtonsTile), findsOneWidget);
    expect(find.byType(AlarmModeTile), findsOneWidget);

    expect(find.text("Everyday"), findsOneWidget);
  });

  testWidgets('Should correctly react to tap on AlarmModeTile', (WidgetTester tester) async {
    await tester.pumpWidget(await UtilsTesting().makeTestableWidget(
        child: AddAlarmPage(
      alarmsListBloc: dummyAlarmsListBloc,
    )));
    expect(find.text("Everyday"), findsOneWidget);

    await tester.tap(find.byType(AlarmModeTile).first);
    await tester.pumpAndSettle(Duration(seconds: 5));

    expect(find.byKey(Key("AlarmModeBottomMenu")), findsOneWidget);
    expect(find.text("Everyday"), findsNWidgets(2));

    await tester.tap(find.text("Own").last);
    await tester.pumpAndSettle(Duration(seconds: 5));

    expect(find.text("Own"), findsOneWidget);
  });

  testWidgets('Should correctly react to tap on WeekButton', (WidgetTester tester) async {
    await tester.pumpWidget(await UtilsTesting().makeTestableWidget(
        child: AddAlarmPage(
      alarmsListBloc: dummyAlarmsListBloc,
    )));

    expect(find.byKey(Key("Fritrue")), findsOneWidget);
    await tester.tap(find.byKey(Key("Fritrue")));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byKey(Key("Frifalse")), findsOneWidget);
  });
}
