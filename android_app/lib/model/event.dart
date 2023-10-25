import 'package:faker/faker.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event extends Alarm {
  final EventType eventType;

  Event(
      {String? id,
      int? minute,
      int? hour,
      bool? state,
      Map<DayOfWeek, bool>? listDays,
      AlarmRepeatMode? repeatMode,
      Color? color,
      int? HandM,
      this.eventType = EventType.TurnOn})
      : super(
            id: id, minute: minute, hour: hour, state: state, repeatMode: repeatMode, color: color, listDays: listDays, HandM: HandM);

  factory Event.random() {
    return Event(
      id: faker.randomGenerator.integer(1000).toString(),
      hour: faker.randomGenerator.integer(24),
      minute: faker.randomGenerator.integer(60),
      state: faker.randomGenerator.boolean(),
      listDays: Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values,
          key: (item) => item, value: (_) => faker.randomGenerator.boolean()),
      repeatMode: faker.randomGenerator.element(AlarmRepeatMode.values),
      color: Color.fromARGB(255, faker.randomGenerator.integer(255), faker.randomGenerator.integer(255),
          faker.randomGenerator.integer(255)),
      eventType: faker.randomGenerator.element(EventType.values),
    );
  }

  Event copyWith({
    String? id,
    int? minute,
    int? hour,
    bool? state,
    Map<DayOfWeek, bool>? listDays,
    AlarmRepeatMode? repeatMode,
    Color? color,
    EventType? eventType,
  }) =>
      Event(
          id: id ?? this.id,
          minute: minute ?? this.minute,
          hour: hour ?? this.hour,
          state: state ?? this.state,
          listDays: listDays ?? this.listDays,
          repeatMode: repeatMode ?? this.repeatMode,
          color: color ?? this.color,
          eventType: eventType ?? this.eventType);

  @override
  factory Event.fromJson(Map<String, dynamic> data) => _$EventFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$EventToJson(this);

  @override
  List<Object?> get props => [id, minute, hour, state, listDays, repeatMode, color.hashCode, eventType];
}

enum EventType { TurnOff, TurnOn, ChangeColor }

extension EventTypeExtension on EventType {
  String getTitle(BuildContext context) {
    switch (this) {
      case EventType.TurnOff:
        return AppLocalizations.of(context)!.turnOff;
      case EventType.TurnOn:
        return AppLocalizations.of(context)!.turnOn;
      case EventType.ChangeColor:
        return AppLocalizations.of(context)!.changeColor;
    }
  }
}