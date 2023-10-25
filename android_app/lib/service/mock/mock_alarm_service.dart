import 'package:faker/faker.dart';
import 'package:led_alarm/model/alarm.dart';
import 'package:led_alarm/service/alarm_service.dart';

class LocalAlarmService extends AlarmService {
  final List<Alarm> alarms = List.generate(faker.randomGenerator.integer(5) + 2, (index) => Alarm.random());

  Future<List<Alarm>> getAlarms() async {
    return List.from(alarms)..sort(compareAlarms);
  }

  @override
  Future<List<Alarm>> addAlarm(Alarm alarm) async {
    alarms.add(alarm);
    return alarms..sort(compareAlarms);
  }

  @override
  Future<List<Alarm>> editAlarm(Alarm alarm ) async {
    int index = alarms.indexWhere((element) => element.id == alarm.id);
    if (alarms.isNotEmpty) alarms.removeWhere((element) => element.id == alarm.id);
    alarms.insert(index, alarm);
    return List.from(alarms..sort(compareAlarms));
  }

  @override
  Future<void> deleteAlarm(Alarm alarm) async {
    alarms.remove(alarm);
  }

  @override
  void deleteSingleAlarm(String uid, Alarm alarm) {
    // przy obecnie stosowanych rozwiązaniach nie powinno potrzebować implementacji
  }

  @override
  Future<List<Alarm>?> getAllAlarmsFromUser(String uid) {
    return Future.value(alarms);
  }

  @override
  void updateSingleAlarm(String uid, Alarm alarm ) {
    // przy obecnie stosowanych rozwiązaniach nie powinno potrzebować implementacji

  }

  @override
  void uploadAlarmToSpecificUsersData(String uid, Alarm alarm) {
    // przy obecnie stosowanych rozwiązaniach nie powinno potrzebować implementacji

  }

  @override
  void setAlarmsModificationDate() {
    // TODO: implement setAlarmsModificationDate
  }
}
