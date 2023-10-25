import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:led_alarm/bloc/alarms_list/alarms_list_bloc.dart';
import 'package:led_alarm/service/alarm_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/view/add_alarm_page/add_alarm_page.dart';
import 'package:led_alarm/view/home_screen/fragment/alarms_list/widget/alarm_card.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AlarmsListPage extends StatelessWidget {
  final ToggleableBoolean isEditingListMode = ToggleableBoolean(false);

  AlarmsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmsListBloc, AlarmsListState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildContent(context, state),
          floatingActionButton: _buildFab(context),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AlarmsListState state) {
    AlarmsListBloc bloc = BlocProvider.of<AlarmsListBloc>(context);
    return BackgroundDecoration(
      child: ListView(
        children: state.alarms
                ?.map(
                  (alarm) => AlarmCard(
                    alarmsListBloc: bloc,
                    alarm: alarm,
                    isEditingListMode: isEditingListMode,
                  ),
                )
                .toList() ??
            [],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Observer(
      builder: (_) => FloatingActionButton.extended(
        elevation: 10,
        splashColor: Theme.of(context).primaryColorLight,
        backgroundColor: isEditingListMode.value ? Color(0xFF80010a) :  Theme.of(context).primaryColorDark,
        onPressed: () => isEditingListMode.value ? _fabOnPressDeleteAlarms(context) : _fabOnPressAddAlarm(context),
        label: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              child: child,
              sizeFactor: animation,
              axis: Axis.horizontal,
            ),
          ),
          child: isEditingListMode.value
              ? Icon(
                  Icons.delete_outlined,
                  size: 28,
                )
              : Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(Icons.add),
                    ),
                    Text( AppLocalizations.of(context)!.addAlarm)
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _fabOnPressAddAlarm(BuildContext context) async {
    final AlarmService _service = locator.get<AlarmService>();
    List<Alarm> alarms = await _service.getAlarms();
    if(alarms.length<5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddAlarmPage(
                  alarmsListBloc: BlocProvider.of<AlarmsListBloc>(context)),
        ),
      );
    }
    else{
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message: AppLocalizations.of(context)!.reachedAlarmLimit,
        ),
        additionalTopPadding: 8,
        showOutAnimationDuration: Duration(seconds: 2),
        displayDuration: Duration(seconds: 1),
      );
    }
  }

  void _fabOnPressDeleteAlarms(BuildContext context) {
    BlocProvider.of<AlarmsListBloc>(context).add(DeleteAlarmsListEvent());
    isEditingListMode.toggle();
  }
}
