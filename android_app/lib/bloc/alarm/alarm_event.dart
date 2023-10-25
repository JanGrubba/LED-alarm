part of 'alarm_bloc.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();
}

class AlarmEventBuilder extends AlarmEvent {
  final Alarm alarm;

  AlarmEventBuilder(this.alarm);

  @override
  List<Object?> get props => [alarm];
}
