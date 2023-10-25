import 'package:catcher/core/catcher.dart';
import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/handlers/email_manual_handler.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:led_alarm/bloc/events_list/alarms_list_bloc.dart';
import 'package:led_alarm/bloc/theme/theme_bloc.dart';
import 'package:led_alarm/controller/locator.dart' as dev;
import 'package:led_alarm/controller/mock/mock_locator.dart' as mock;
import 'package:led_alarm/view/error_pages/catcher_report_page.dart';
import 'package:led_alarm/view/home_screen/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:flutter/services.dart';
import 'package:led_alarm/view/login_screen/email_login_screen.dart';
import 'package:led_alarm/view/login_screen/email_registration_screen.dart';
import 'package:led_alarm/view/login_screen/firebase_connection_screen.dart';
import 'package:led_alarm/view/sandbox/intro_page.dart';
import 'package:led_alarm/view/sandbox/sandbox_page.dart';
import 'package:provider/provider.dart';
import 'package:catcher/catcher.dart';

import 'bloc/alarms_list/alarms_list_bloc.dart';
import 'controller/secure_storage_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String mode = _initLocator();

  // enable transparent android toolbar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  final Widget homePage = await _getHomePage();

  CatcherOptions debugOptions = _initCatcherInDebugMode();

  CatcherOptions releaseOptions = _initCatcherInReleaseMode();

  await Firebase.initializeApp();

  Catcher(
    runAppFunction: () {
      runApp(MyApp(home: homePage, mode : mode));
    },
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );
}

String _initLocator() {
  const String mode = String.fromEnvironment('mode');
  if (mode == "dev") {
    print("\x1B[32mMODE : DEV \x1B[0m");
    dev.setup();
  } else {
    print("\x1B[33mMODE : TEST \x1B[0m");
    mock.setup();
  }
  return mode;
}

Future<Widget> _getHomePage() async {
  final SecureStorageController _secureStorageController = locator.get<SecureStorageController>();
  bool isExecuted = await _secureStorageController.containSecureData(SecureStorageKeys.INTRO_PAGE_FLAG);
  if (isExecuted) {
    return HomePage(title: "LED Alarm");
  } else {
    await _secureStorageController.writeSecureData(SecureStorageKeys.INTRO_PAGE_FLAG, "executed");
    return IntroScreen();
  }
}

CatcherOptions _initCatcherInDebugMode() {
  return CatcherOptions(
    CatcherReportPage(),
    [
      /// Prints stacktrace in console
      ConsoleHandler(),

      /// Opens email client - fills the fields
      /// SEends informations about issues to app creators
      EmailManualHandler(["alarmLedDev@gmail.com"],
          enableDeviceParameters: true,
          enableStackTrace: true,
          enableCustomParameters: false,
          enableApplicationParameters: true,
          sendHtml: true,
          emailTitle: "[LOGS] -  ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
          printLogs: true),
    ],
  );
}

CatcherOptions _initCatcherInReleaseMode() {
  return CatcherOptions(
    CatcherReportPage(),
    [
      EmailManualHandler(["alarmLedDev@gmail.com"],
          enableDeviceParameters: true,
          enableStackTrace: true,
          enableCustomParameters: false,
          enableApplicationParameters: true,
          sendHtml: true,
          emailTitle: "[LOGS] -  ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
          printLogs: true),
      ConsoleHandler(),
    ],
  );
}

class MyApp extends StatelessWidget {
  final Widget home;
  final String mode;

  MyApp({required this.home, required this.mode});

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  /// Created for needs of function `makeTestableWidget` from file util_functions_for_test.dart
  Widget buildContent() {
    return FutureProvider<ThemeBloc>(
      initialData: ThemeBloc(),
      create: (_) {},
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeBloc>(
            create: (_) => ThemeBloc(),
          ),
          ChangeNotifierProvider<AlarmsListBloc>(
            create: (_) => AlarmsListBloc()..add(GetAlarmsListEvent()),
          ),
          ChangeNotifierProvider<EventsListBloc>(
            create: (_) => EventsListBloc()..add(GetEventsListEvent()),
          )
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'LED Alarm',
              debugShowCheckedModeBanner: false,
              theme: state.themeData,
              // home: home,
              navigatorKey: Catcher.navigatorKey,
              initialRoute: mode == "dev" ? '/firebaseintro' : '/home',
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [const Locale('en', 'US'), const Locale('pl', 'PL')],
              routes: {
                '/sandbox': (context) => SandBoxPage(),
                //'/add_alarm': (context) => AddAlarmPage(),
                '/home': (context) => home,
                '/firebaseintro': (context) => FireBaseIntroScreen(),
                '/email_register': (context) => EmailSignUp(),
                '/email_login': (context) => EmailLogIn(),
              },
            );
          },
        ),
      ),
    );
  }
}
