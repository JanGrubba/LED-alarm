import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:led_alarm/service/alarm_service.dart';
import 'package:led_alarm/service/authentication_service.dart';
import 'package:led_alarm/service/event_service.dart';
import 'package:led_alarm/service/firebase_communication_service.dart';
import 'package:led_alarm/service/mock/mock_alarm_service.dart';
import 'package:led_alarm/service/mock/mock_authentication_service.dart';
import 'package:led_alarm/service/mock/mock_communication_service.dart';
import 'package:led_alarm/service/mock/mock_event_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<SecureStorageController>(() => SecureStorageController());
  locator.registerLazySingleton<AlarmService>(() => LocalAlarmService());
  locator.registerLazySingleton<EventService>(() => LocalEventService());
  locator.registerLazySingleton<FirebaseCommunicationService>(() => MockCommunicationService());
  // locator.registerLazySingleton<AuthenticationService>(() => MockAuthenticationService());
  locator.registerLazySingleton<AuthenticationService>(() => ImplAuthenticationService());
}
