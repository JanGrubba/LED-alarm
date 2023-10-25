part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  final Event event;

  const EventState({required this.event});

  @override
  List<Object> get props => [event];
}

class EventStateBuilder extends EventState {
  EventStateBuilder({required Event event}) : super(event: event);
}
