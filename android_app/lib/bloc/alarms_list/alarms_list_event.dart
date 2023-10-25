part of 'alarms_list_bloc.dart';

@immutable
abstract class AlarmsListEvent extends Equatable {
  List<Object?> get props => [];
}

class GetAlarmsListEvent extends AlarmsListEvent {}


class AddNewAlarmEvent extends AlarmsListEvent {
  final Alarm alarm;

  AddNewAlarmEvent(this.alarm);

  @override
  List<Object?> get props => [alarm];
}

class EditAlarmEvent extends AlarmsListEvent {
  final Alarm alarm;

  EditAlarmEvent(this.alarm);

  @override
  List<Object?> get props => [alarm];
}


class AddToDeletionAlarmsListEvent extends AlarmsListEvent {
  final Alarm alarm;

  AddToDeletionAlarmsListEvent(this.alarm);

  @override
  List<Object?> get props => [alarm];
}

class DeleteAlarmsListEvent extends AlarmsListEvent {}
