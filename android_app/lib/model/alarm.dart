import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nanoid/nanoid.dart';

part 'alarm.g.dart';

@JsonSerializable(anyMap: true)
class Alarm extends Equatable {
  final String id;

  @JsonKey(ignore: true)
  final int hour;
  @JsonKey(ignore: true)
  final int minute;

  final int HandM;


  final bool state;
  final Map<DayOfWeek, bool> listDays;
  final AlarmRepeatMode repeatMode;

  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color color;

  Alarm({
    String? id,
    int? minute,
    int? hour,
    bool? state,
    Map<DayOfWeek, bool>? listDays,
    AlarmRepeatMode? repeatMode,
    Color? color,
    int? HandM,
  })
      : this.id = id ?? nanoid(10),
        this.HandM = (hour!=null && minute!=null) ? hour*60+minute : 0,
        this.minute = minute ?? ((HandM!=null) ? (HandM%60) :  TimeOfDay.now().minute),
        this.hour = hour ?? ((HandM!=null) ? ((HandM/60).floor()) :  TimeOfDay.now().hour),
        this.state = state ?? true,
        this.repeatMode = repeatMode ?? AlarmRepeatMode.Ed,
        this.color = color ?? Color(0xFFFFFFFF),
        this.listDays =
            listDays ?? Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values, key: (day) => day, value: (_) => true);

  factory Alarm.random() {
    return Alarm(
      id: faker.randomGenerator.integer(1000).toString(),
      hour: faker.randomGenerator.integer(24),
      minute: faker.randomGenerator.integer(60),
      state: faker.randomGenerator.boolean(),
      listDays: Map<DayOfWeek, bool>.fromIterable(DayOfWeek.values,
          key: (item) => item, value: (_) => faker.randomGenerator.boolean()),
      repeatMode: faker.randomGenerator.element(AlarmRepeatMode.values),
      color: Color.fromARGB(255, faker.randomGenerator.integer(255), faker.randomGenerator.integer(255),
          faker.randomGenerator.integer(255)),
    );
  }

  Alarm copyWith({
    String? id,
    int? minute,
    int? hour,
    bool? state,
    Map<DayOfWeek, bool>? listDays,
    AlarmRepeatMode? repeatMode,
    Color? color,
  }) =>
      Alarm(
          id: id ?? this.id,
          minute: minute ?? this.minute,
          hour: hour ?? this.hour,
          state: state ?? this.state,
          listDays: listDays ?? this.listDays,
          repeatMode: repeatMode ?? this.repeatMode,
          color: color ?? this.color);

  factory Alarm.fromJson(Map<String, dynamic> data) => _$AlarmFromJson(data);

  Map<String, dynamic> toJson() => _$AlarmToJson(this);

  String getFormattedListDaysShort(BuildContext context) {
    StringBuffer buffer = new StringBuffer();

    if (repeatMode != AlarmRepeatMode.Ed) {
      listDays.forEach(
            (key, value) {
          if (value) {
            buffer.write(key.getName(context));
            buffer.write(' ');
          }
        },
      );
      buffer.write(' | ');
    }

    buffer.write(repeatMode.getTitle(context));
    return buffer.toString();
  }

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  @override
  List<Object?> get props => [id, minute, hour, state, listDays, repeatMode, color];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is Alarm &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              hour == other.hour &&
              minute == other.minute &&
              state == other.state &&
              listDays == other.listDays &&
              HandM == other.HandM &&
              repeatMode == other.repeatMode &&
              color.value == other.color.value;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      hour.hashCode ^
      minute.hashCode ^
      state.hashCode ^
      listDays.hashCode ^
      repeatMode.hashCode ^
      HandM.hashCode ^
      color.hashCode;
}

enum DayOfWeek { MN, TU, WD, TH, FR, ST, SU }

extension DayOfWeekExtension on DayOfWeek {
  String getName(BuildContext context) {
    switch (this) {
      case DayOfWeek.MN:
        return AppLocalizations.of(context)!.mondayShort;
      case DayOfWeek.TU:
        return AppLocalizations.of(context)!.tuesdayShort;
      case DayOfWeek.WD:
        return AppLocalizations.of(context)!.wednesdayShort;
      case DayOfWeek.TH:
        return AppLocalizations.of(context)!.thursdayShort;
      case DayOfWeek.FR:
        return AppLocalizations.of(context)!.fridayShort;
      case DayOfWeek.ST:
        return AppLocalizations.of(context)!.saturdayShort;
      case DayOfWeek.SU:
        return AppLocalizations.of(context)!.sundayShort;
    }
  }
}

enum AlarmRepeatMode { Ed, Once, MtF, Own }

extension AlarmRepeatModeExtension on AlarmRepeatMode {
  String getTitle(BuildContext context) {
    switch (this) {
      case AlarmRepeatMode.Ed:
        return AppLocalizations.of(context)!.everyday;
      case AlarmRepeatMode.Once:
        return AppLocalizations.of(context)!.once;
      case AlarmRepeatMode.MtF:
        return AppLocalizations.of(context)!.mondayToFriday;
      case AlarmRepeatMode.Own:
        return AppLocalizations.of(context)!.own;
    }
  }
}

Color colorFromJson(Map<Object?, dynamic> data) =>
    Color(
        data['value'] as int
    ).withAlpha(255);

Map<String, dynamic> colorToJson(Color color) =>
    <String, dynamic>{
      'value': ((color.red * 65536) + (color.green * 256) + color.blue)
    };
