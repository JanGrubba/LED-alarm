part of 'alarms_list_bloc.dart';

@immutable
class EventsListState extends Equatable {
  final List<Event>? events;
  final List<Event>? eventsToDelete;

  const EventsListState({this.events, this.eventsToDelete});

  EventsListState copyWith({List<Event>? events, List<Event>? eventsToDelete}) =>
      EventsListState(events: events ?? this.events, eventsToDelete: eventsToDelete ?? this.eventsToDelete);

  @override
  List<Object?> get props => [events, eventsToDelete];
}
