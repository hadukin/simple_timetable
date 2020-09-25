import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_timetable/src/event.dart';
import 'package:simple_timetable/src/event_position.dart';
import 'package:dart_date/dart_date.dart';

class EventCard extends StatefulWidget {
  EventCard({Key key, this.position, this.event, this.buildCard})
      : super(key: key);
  final EventPosition position;
  final Event event;
  final Widget Function(Event event, bool isPast) buildCard;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  Timer _timer;
  ValueNotifier<DateTime> _now = ValueNotifier(DateTime.now());

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _now.value = DateTime.now();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _now.value = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _now,
      builder: (context, v, child) {
        DateTime _current =
            DateTime.utc(v.year, v.month, v.day, v.hour, v.minute);
        bool _isPast = _current > widget.event.end;
        return Positioned(
          top: widget.position.top,
          left: widget.position.left,
          child: Container(
            decoration: widget.buildCard == null
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blue.withOpacity(0.3),
                  )
                : null,
            height: widget.position.height,
            width: widget.position.width,
            child: widget.buildCard != null
                ? widget.buildCard(widget.event, _isPast)
                : Container(),
          ),
        );
      },
    );
  }
}
