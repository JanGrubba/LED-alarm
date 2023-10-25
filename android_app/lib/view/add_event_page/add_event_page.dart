import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:led_alarm/bloc/event/event_bloc.dart';
import 'package:led_alarm/bloc/events_list/alarms_list_bloc.dart';
import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:led_alarm/model/event.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/function/util_date_functions.dart';
import 'package:led_alarm/view/add_alarm_page/widget/alarm_mode_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/color_picker_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/spinner_time_picker_tile.dart';
import 'package:led_alarm/view/add_alarm_page/widget/week_buttons_row_tile.dart';
import 'package:led_alarm/view/add_event_page/widget/event_type_tile.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddEventPage extends StatefulWidget {
  final Event? event;
  final EventsListBloc eventsListBloc;

  const AddEventPage({Key? key, required this.eventsListBloc, this.event}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState(event);
}

class _AddEventPageState extends State<AddEventPage> {
  final Event? event;
  final EventBloc bloc;
  late Intro intro;

  _AddEventPageState(this.event) : this.bloc = EventBloc(event);

  @override
  void initState() {
    _initIntroduction();
    _startIntroductionIfFirstTime();
    super.initState();
  }

  void _initIntroduction() {
    intro = Intro(
      stepCount: 8,
      maskClosable: true,
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          'W tym oknie możesz dodać nową akcję.',
          'Wybierz godzinę o której akcja ma zostać wywołana',
          'Wybierz dni w których akcja ma być wywoływana',
          'Wybierz typ akcji - włacz oświetlenie, wyłacz lub zmień kolor',
          'Jeśli zdecydujesz się włączyć oświetlenie możesz ustawić kolor światła!',
          'Zamiast ręcznie wybierać w jakie dni ma się włączać akcja, możesz skorzystać z gotowych propozycji!',
          'Zapisz przygotowane wydarzenie ...',
          '... lub go odrzuć',
        ],
        buttonTextBuilder: (currPage, totalPage) {
          return currPage < totalPage - 1 ? AppLocalizations.of(context)!.next : AppLocalizations.of(context)!.finish;
        },
      ),
    );
  }

  void _startIntroductionIfFirstTime() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) async {
        final SecureStorageController _secureStorageController = locator.get<SecureStorageController>();
        bool isExecuted =
            await _secureStorageController.containSecureData(SecureStorageKeys.ADD_EVENT_INTRODUCTION_FLAG);
        if (!isExecuted && widget.event == null) {
          intro.start(context);
          _secureStorageController.writeSecureData(SecureStorageKeys.ADD_EVENT_INTRODUCTION_FLAG, "executed");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            key: intro.keys[0],
            elevation: 0.0,
            centerTitle: true,
            title: _createAppBarTitle(),
            backgroundColor: Theme.of(context).primaryColor,
            leading: _createAppBarLeading(),
            actions: _createAppBarActions(),
          ),
          body: Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: [
                  _buildSpaceBetween(),
                  _buildSpinnerTimePickerTile(),
                  _buildSpaceBetween(),
                  _buildWeekButtonsTile(),
                  _buildSpaceBetween(),
                  Divider(indent: 30, endIndent: 30, color: Colors.white38),
                  _buildEventTypeTile(),
                  Divider(indent: 30, endIndent: 30, color: Colors.white38),
                  _buildColorPickerTile(),
                  _buildEventModeTile(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createAppBarTitle() {
    int hour = bloc.state.event.hour;
    int minute = bloc.state.event.minute;

    var timeDifference = UtilDateFunction.calculateTimeDifferenceFromNow(hour: hour, minute: minute);

    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.addEvent,
          style: MyTextStyle.getBody1TextStyleWithMatchedColor(context),
        ),
        Text(
          "${AppLocalizations.of(context)!.actionIn} : " +
              timeDifference.hour.toString().padLeft(2, '0') +
              ':' +
              timeDifference.minute.toString().padLeft(2, '0'),
          style: MyTextStyle.getBody2TextStyleWithMatchedColor(context),
        ),
      ],
    );
  }

  Widget _createAppBarLeading() {
    return IconButton(
      iconSize: 28,
      padding: EdgeInsets.only(left: 16),
      icon: new Icon(
        Icons.close,
        key: intro.keys[7],
        color: MyTextStyle.getMatchingColorByTheme(context: context),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  List<Widget> _createAppBarActions() {
    return <Widget>[
      IconButton(
        iconSize: 28,
        padding: EdgeInsets.only(right: 16),
        icon: Icon(
          Icons.done,
          key: intro.keys[6],
          color: MyTextStyle.getMatchingColorByTheme(context: context),
        ),
        onPressed: () {
          _saveEvent();
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: AppLocalizations.of(context)!.eventHasBeenAdded,
            ),
            additionalTopPadding: 8,
            showOutAnimationDuration: Duration(seconds: 2),
            displayDuration: Duration(seconds: 1),
          );
          Navigator.of(context).pop();
        },
      )
    ];
  }

  void _saveEvent() {
    Event event = bloc.state.event.copyWith();
    if (widget.event != null) {
      widget.eventsListBloc.add(EditEventEvent(event));
    } else {
      widget.eventsListBloc.add(AddNewEventEvent(event));
    }
  }

  Widget _buildSpinnerTimePickerTile() {
    return SpinnerTimePickerTile(
      key: intro.keys[1],
      alarm: bloc.state.event,
      onChangedHour: (hour) {
        bloc.add(
          EventEventBuilder(
            bloc.state.event.copyWith(hour: hour),
          ),
        );
      },
      onChangedMinute: (minute) {
        bloc.add(
          EventEventBuilder(
            bloc.state.event.copyWith(minute: minute),
          ),
        );
      },
    );
  }

  Widget _buildWeekButtonsTile() {
    return WeekButtonsTile(
      key: intro.keys[2],
      onChange: (listDays) => bloc.add(
        EventEventBuilder(
          bloc.state.event.copyWith(repeatMode: AlarmRepeatMode.Own, listDays: listDays),
        ),
      ),
      initMode: bloc.state.event.repeatMode,
      listDays: bloc.state.event.listDays,
    );
  }

  Widget _buildEventTypeTile() {
    return Padding(
      key: intro.keys[3],
      padding: EdgeInsets.only(left: 8, right: 16),
      child: EventTypeTile(
        event: bloc.state.event,
        onChoose: (event, mode) {
          bloc.add(
            EventEventBuilder(
              event.copyWith(
                eventType: mode,
              ),
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildColorPickerTile() {
    return Conditional.single(
      context: context,
      conditionBuilder: (_) => (bloc.state.event.eventType != EventType.TurnOff),
      widgetBuilder: (_) => Column(
        children: [
          Padding(
            key: intro.keys[4],
            padding: EdgeInsets.only(left: 24, right: 16),
            child: ColorPickerTile(
              onPress: (chooseColor) {
                bloc.add(
                  EventEventBuilder(
                    bloc.state.event.copyWith(color: chooseColor),
                  ),
                );
                Navigator.pop(context);
              },
              initColor: widget.event != null ? widget.event?.color ?? null : null,
            ),
          ),
          Divider(indent: 30, endIndent: 30, color: Colors.white38),
        ],
      ),
      fallbackBuilder: (_) => const SizedBox.shrink(),
    );
  }

  Widget _buildEventModeTile() {
    return Padding(
      key: intro.keys[5],
      padding: EdgeInsets.only(left: 8, right: 16),
      child: AlarmModeTile<Event>(
        alarm: bloc.state.event,
        onChoose: (event, mode) {
          bloc.add(
            EventEventBuilder(
              event.copyWith(
                repeatMode: mode,
                listDays: _prepareWeekButtonsRow(mode),
              ),
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSpaceBetween({double height = 30}) {
    return SizedBox(
      height: height,
    );
  }

  Map<DayOfWeek, bool>? _prepareWeekButtonsRow(AlarmRepeatMode mode) {
    switch (mode) {
      case AlarmRepeatMode.Ed:
        return Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values, key: (item) => item, value: (_) => true);
      case AlarmRepeatMode.Once:
        return null;
      case AlarmRepeatMode.MtF:
        return Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values.getRange(0, 5),
            key: (item) => item, value: (_) => true)
          ..addAll(Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values.getRange(5, 7),
              key: (item) => item, value: (_) => false));
      case AlarmRepeatMode.Own:
        return null;
    }
  }
}
