// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeTableEvent _$TimeTableEventFromJson(Map<String, dynamic> json) {
  return TimeTableEvent(
    startDate: _fromJson(json['startDate'] as String),
    payload: json['payload'] == null
        ? null
        : EventPayload.fromJson(json['payload'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TimeTableEventToJson(TimeTableEvent instance) =>
    <String, dynamic>{
      'payload': instance.payload,
      'startDate': _toJson(instance.startDate),
    };

EventPayload _$EventPayloadFromJson(Map<String, dynamic> json) {
  return EventPayload(
    eventDate: _fromJson(json['eventDate'] as String),
    eventStart: json['eventStart'] as String,
    eventEnd: json['eventEnd'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$EventPayloadToJson(EventPayload instance) =>
    <String, dynamic>{
      'eventDate': _toJson(instance.eventDate),
      'eventStart': instance.eventStart,
      'eventEnd': instance.eventEnd,
      'title': instance.title,
    };
