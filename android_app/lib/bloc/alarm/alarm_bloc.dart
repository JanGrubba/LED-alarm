import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:led_alarm/util/common_package.dart';

part 'alarm_event.dart';

part 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc(Alarm? alarm) : super(AlarmStateBuilder(alarm: alarm ?? Alarm()));

  @override
  Stream<AlarmState> mapEventToState(AlarmEvent event) async* {
    if (event.runtimeType == AlarmEventBuilder) {
      yield AlarmStateBuilder(alarm: (event as AlarmEventBuilder).alarm);
    }
  }
}
