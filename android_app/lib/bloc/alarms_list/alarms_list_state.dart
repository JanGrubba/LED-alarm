part of 'alarms_list_bloc.dart';

@immutable
class AlarmsListState extends Equatable {
  final List<Alarm>? alarms;
  final List<Alarm>? alarmsToDelete;

  const AlarmsListState({this.alarms, this.alarmsToDelete});

  AlarmsListState copyWith({List<Alarm>? alarms, List<Alarm>? alarmsToDelete}) =>
      AlarmsListState(alarms: alarms ?? this.alarms, alarmsToDelete: alarmsToDelete ?? this.alarmsToDelete);

  @override
  List<Object?> get props => [alarms, alarmsToDelete];
}
