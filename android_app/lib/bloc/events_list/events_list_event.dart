part of 'alarms_list_bloc.dart';

@immutable
abstract class EventsListEvent extends Equatable {
  List<Object?> get props => [];
}

class GetEventsListEvent extends EventsListEvent {}

class AddNewEventEvent extends EventsListEvent {
  final Event event;

  AddNewEventEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class EditEventEvent extends EventsListEvent {
  final Event event;

  EditEventEvent(this.event);

  @override
  List<Object?> get props => [event];
}


class AddToDeletionEventsListEvent extends EventsListEvent {
  final Event event;

  AddToDeletionEventsListEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class DeleteEventsListEvent extends EventsListEvent {}
