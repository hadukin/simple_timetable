import 'package:flutter/material.dart';
import 'package:simple_timetable/src/event.dart';
import 'package:simple_timetable/src/event_card.dart';
import 'package:simple_timetable/src/event_position.dart';

List<Widget> eventsCreate<T>({
  required List<List<Event<T>>> events,
  required int dayStartFrom,
  required double cellWidth,
  required double cellHeight,
  required Widget Function(Event<T> event, bool isPast)? buildCard,
}) {
  final List<Widget> listWidgets = [];
  for (final item in events) {
    for (int i = 0; i < item.length; i++) {
      final EventPosition position = eventPosition(
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        dayStartFrom: dayStartFrom,
        start: item[i].start,
        end: item[i].end,
        left: i,
        count: item.length,
      );
      listWidgets.add(EventCard<T>(
        event: item[i],
        position: position,
        buildCard: buildCard,
      ));
    }
  }

  return listWidgets;
}
