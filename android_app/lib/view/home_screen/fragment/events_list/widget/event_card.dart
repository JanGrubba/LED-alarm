import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:led_alarm/bloc/events_list/alarms_list_bloc.dart';
import 'package:led_alarm/model/event.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/view/add_event_page/add_event_page.dart';

class EventCard extends StatefulWidget {
  final EventsListBloc eventsListBloc;
  final Event event;
  final ToggleableBoolean isEditingListMode;

  const EventCard({
    Key? key,
    required this.eventsListBloc,
    required this.event,
    required this.isEditingListMode,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return _createEventCard();
  }

  Widget _createEventCard() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: GestureDetector(
        onLongPress: toggleEditingMode,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Stack(
            children: [
              _createColorDecoration(),
              _createListTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createColorDecoration() {
    return Conditional.single(
      context: context,
      conditionBuilder: (_) => (widget.event.eventType != EventType.TurnOff),
      widgetBuilder: (_) => Positioned.fill(
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 10.0,
            height: 50.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), bottomLeft: Radius.circular(40.0)),
                color: widget.event.color,
              ),
            ),
          ),
        ),
      ),
      fallbackBuilder: (_) => const SizedBox.shrink(),
    );
  }

  Widget _createListTile() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 0, bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: _createTitle(context, widget.event),
            subtitle: _createSubTitle(context, widget.event),
            onTap: _onTapCard,
            trailing: _createTrailing(),
          ),
        ],
      ),
    );
  }

  void _onTapCard() {
    widget.isEditingListMode.value
        ? checkboxOnChanged(false)
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventPage(eventsListBloc: widget.eventsListBloc, event: widget.event),
            ),
          );
  }

  Widget _createTrailing() {
    return Observer(
      builder: (_) => AnimatedSwitcher(
        child: widget.isEditingListMode.value
            ? Padding(
                padding: const EdgeInsets.only(right: 11),
                child: Checkbox(
                  value: widget.eventsListBloc.state.eventsToDelete?.contains(widget.event) ?? false,
                  onChanged: checkboxOnChanged,
                ),
              )
            : Switch(
                onChanged: switchOnChanged,
                value: widget.event.state,
                activeColor: Theme.of(context).primaryColor.withAlpha(250)),
        duration: Duration(milliseconds: 400),
      ),
    );
  }

  void switchOnChanged(bool? value) {
    widget.eventsListBloc.add(EditEventEvent(widget.event.copyWith(state: value)));
  }

  void checkboxOnChanged(bool? value) {
    setState(() {
      widget.eventsListBloc.add(AddToDeletionEventsListEvent(widget.event));
    });
  }

  void toggleEditingMode() {
    setState(() {
      widget.isEditingListMode.toggle();
    });
  }

  Widget _createTitle(BuildContext context, Event event) {
    return Text(event.time.format(context), style: TextStyle(fontSize: 22));
  }

  Widget _createSubTitle(BuildContext context, Event event) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${AppLocalizations.of(context)!.action}: ${event.eventType.getTitle(context)}",
            overflow: TextOverflow.ellipsis),
        SizedBox(height: 2),
        Text(event.getFormattedListDaysShort(context), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
