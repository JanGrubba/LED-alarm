part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();
}

class EventEventBuilder extends EventEvent {
  final Event event;

  EventEventBuilder(this.event);

  @override
  List<Object?> get props => [event];
}
