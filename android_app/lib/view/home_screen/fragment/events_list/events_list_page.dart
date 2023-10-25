import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:led_alarm/bloc/events_list/alarms_list_bloc.dart';
import 'package:led_alarm/model/event.dart';
import 'package:led_alarm/service/event_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/view/add_event_page/add_event_page.dart';
import 'package:led_alarm/view/home_screen/fragment/events_list/widget/event_card.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EventsListPage extends StatefulWidget {
  EventsListPage({Key? key}) : super(key: key);

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  final ToggleableBoolean isEditingListMode = ToggleableBoolean(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsListBloc, EventsListState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildContent(context, state),
          floatingActionButton: _buildFab(context),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, EventsListState state) {
    EventsListBloc bloc = BlocProvider.of<EventsListBloc>(context);
    return BackgroundDecoration(
      child: ListView(
        children: state.events?.map((event) {
              return EventCard(
                eventsListBloc: bloc,
                event: event,
                isEditingListMode: isEditingListMode,
              );
            }).toList() ??
            [],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Observer(
      builder: (_) => FloatingActionButton.extended(
        backgroundColor: isEditingListMode.value ? Color(0xFF80010a) :  Theme.of(context).primaryColorDark,
        onPressed: () => isEditingListMode.value ? _fabOnPressDeleteEvents(context) : _fabOnPressAddEvent(context),
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
                    Text(AppLocalizations.of(context)!.addEvent)
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _fabOnPressAddEvent(BuildContext context) async {
    final EventService _service = locator.get<EventService>();
    List<Event> events = await _service.getEvents();
    if(events.length<5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddEventPage(
                  eventsListBloc: BlocProvider.of<EventsListBloc>(context)),
        ),
      );
    }
    else{
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message: AppLocalizations.of(context)!.reachedEventLimit,
        ),
        additionalTopPadding: 8,
        showOutAnimationDuration: Duration(seconds: 2),
        displayDuration: Duration(seconds: 1),
      );
    }
  }

  void _fabOnPressDeleteEvents(BuildContext context) {
    BlocProvider.of<EventsListBloc>(context).add(DeleteEventsListEvent());
    isEditingListMode.toggle();
  }
}
