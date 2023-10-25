import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:led_alarm/controller/locator.dart';
import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:led_alarm/style/app_theme.dart';
import 'package:led_alarm/util/common_package.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> with ChangeNotifier {
  ThemeBloc() : super(ThemeInitial());

  @override
  Stream<ThemeChangeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeInit) {
      String? readData = await locator.get<SecureStorageController>().readSecureData("theme");

      AppTheme appTheme;
      if (readData != null) {
        appTheme = fromString(readData);
      } else
        appTheme = AppTheme.Light;

      yield ThemeChangeState(name: appTheme.name, themeData: appThemeData[appTheme]!);
    } else if (event is ThemeChanged) {
      await locator.get<SecureStorageController>().writeSecureData("theme", event.theme.name);

      yield ThemeChangeState(name: event.theme.name, themeData: appThemeData[event.theme]!);
    }
  }
}
