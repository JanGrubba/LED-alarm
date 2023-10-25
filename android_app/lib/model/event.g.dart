// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String?,
      state: json['state'] as bool?,
      listDays: (json['listDays'] as Map?)?.map(
        (k, e) => MapEntry(_$enumDecode(_$DayOfWeekEnumMap, k), e as bool),
      ),
      repeatMode:
          _$enumDecodeNullable(_$AlarmRepeatModeEnumMap, json['repeatMode']),
      color: colorFromJson(json['color'] as Map),
      HandM: json['HandM'] as int?,
      eventType: _$enumDecodeNullable(_$EventTypeEnumMap, json['eventType']) ??
          EventType.TurnOn,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'HandM': instance.HandM,
      'state': instance.state,
      'listDays':
          instance.listDays.map((k, e) => MapEntry(_$DayOfWeekEnumMap[k], e)),
      'repeatMode': _$AlarmRepeatModeEnumMap[instance.repeatMode],
      'color': colorToJson(instance.color),
      'eventType': _$EventTypeEnumMap[instance.eventType],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$DayOfWeekEnumMap = {
  DayOfWeek.MN: 'MN',
  DayOfWeek.TU: 'TU',
  DayOfWeek.WD: 'WD',
  DayOfWeek.TH: 'TH',
  DayOfWeek.FR: 'FR',
  DayOfWeek.ST: 'ST',
  DayOfWeek.SU: 'SU',
};

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$AlarmRepeatModeEnumMap = {
  AlarmRepeatMode.Ed: 'Ed',
  AlarmRepeatMode.Once: 'Once',
  AlarmRepeatMode.MtF: 'MtF',
  AlarmRepeatMode.Own: 'Own',
};

const _$EventTypeEnumMap = {
  EventType.TurnOff: 'TurnOff',
  EventType.TurnOn: 'TurnOn',
  EventType.ChangeColor: 'ChangeColor',
};
