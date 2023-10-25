import 'package:get_it/get_it.dart';
import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:led_alarm/service/alarm_service.dart';
import 'package:led_alarm/service/event_service.dart';
import 'package:led_alarm/service/authentication_service.dart';
import 'package:led_alarm/service/firebase_communication_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<SecureStorageController>(() => SecureStorageController());
  locator.registerLazySingleton<FirebaseCommunicationService>(() => ImplFirebaseCommunicationService());
  locator.registerLazySingleton<AlarmService>(() => ImplAlarmService());
  locator.registerLazySingleton<EventService>(() => ImplEventService());
  locator.registerLazySingleton<AuthenticationService>(() => ImplAuthenticationService());
}
