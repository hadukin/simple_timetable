import 'package:flutter/material.dart';

class Event<T> {
  final DateTime start;
  final DateTime end;
  final DateTime date;
  final T payload;

  Event({
    @required this.start,
    @required this.end,
    @required this.date,
    this.payload,
  });
}
