import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:led_alarm/model/event.dart';

part 'event_event.dart';

part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc(Event? event) : super(EventStateBuilder(event: event ?? Event()));

  @override
  Stream<EventState> mapEventToState(EventEvent event) async* {
    if (event.runtimeType == EventEventBuilder) {
      yield EventStateBuilder(event: (event as EventEventBuilder).event);
    }
  }
}
