import 'package:flutter/foundation.dart';
import 'package:dart_date/dart_date.dart';

class EventPosition {
  final double height;
  final double width;
  final double top;
  final double left;

  EventPosition({
    required this.height,
    required this.top,
    required this.left,
    required this.width,
  });
}

EventPosition eventPosition({
  required DateTime start,
  required DateTime end,
  required double cellHeight,
  required int dayStartFrom,
  required int left,
  required int count,
  required double cellWidth,
  int indent = 6,
}) {
  final double _t = cellHeight / 60;
  final double _height = start.differenceInMinutes(end).abs() * _t;
  final double _width = (cellWidth.toDouble() / count) - indent;
  final double _top =
      (((dayStartFrom - start.hour).abs()) * cellHeight) + start.minute;

  final double _left = count > 1
      ? ((_width * left) + (indent / count)) + (indent * left)
      : (_width * left) + (indent / 2);

  return EventPosition(
    height: _height,
    top: _top,
    left: _left,
    width: _width,
  );
}
