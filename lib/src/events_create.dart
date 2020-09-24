import 'package:flutter/material.dart';
import 'package:simple_timetable/src/event.dart';
import 'package:simple_timetable/src/event_card.dart';
import 'package:simple_timetable/src/event_position.dart';

List<Widget> eventsCreate({
  Map<int, List<Event>> events,
  @required int dayStartFrom,
  @required double cellWidth,
  @required double cellHeight,
  cardBuilder,
}) {
  List<Widget> listWidgets = [];
  for (final item in events.entries) {
    for (int i = 0; i < item.value.length; i++) {
      EventPosition position = eventPosition(
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        dayStartFrom: dayStartFrom,
        start: item.value[i].start,
        end: item.value[i].end,
        left: i,
        count: item.value.length,
      );
      listWidgets.add(EventCard(
        event: item.value[i],
        position: position,
        cardBuilder: cardBuilder,
      ));
    }
  }

  return listWidgets;
}
