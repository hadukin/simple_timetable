import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'event.g.dart';

@JsonSerializable()
class TimeTableEvent {
  final EventPayload data;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime startDate;

  TimeTableEvent({
    this.startDate,
    this.data,
  });

  factory TimeTableEvent.fromJson(Map<String, dynamic> json) =>
      _$TimeTableEventFromJson(json);
  Map<String, dynamic> toJson() => _$TimeTableEventToJson(this);
}

@JsonSerializable()
class EventPayload {
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime eventDate;

  final String eventStart;
  final String eventEnd;
  final String title;

  EventPayload({this.eventDate, this.eventStart, this.eventEnd, this.title});

  factory EventPayload.fromJson(Map<String, dynamic> json) =>
      _$EventPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$EventPayloadToJson(this);
}

final _dateFormatter = new DateFormat('M/d/yyyy');
DateTime _fromJson(String date) => DateTime.parse(date);
String _toJson(DateTime date) => _dateFormatter.format(date);
