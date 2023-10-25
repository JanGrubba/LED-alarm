part of 'alarm_bloc.dart';

abstract class AlarmState extends Equatable {
  final Alarm alarm;

  const AlarmState({required this.alarm});

  @override
  List<Object> get props => [alarm];
}

class AlarmStateBuilder extends AlarmState {
  AlarmStateBuilder({required Alarm alarm}) : super(alarm: alarm);
}
