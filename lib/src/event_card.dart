import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_timetable/src/event.dart';
import 'package:simple_timetable/src/event_position.dart';

class EventCard<T> extends StatefulWidget {
  const EventCard({
    Key? key,
    required this.position,
    required this.event,
    this.buildCard,
  }) : super(key: key);
  final EventPosition position;
  final Event<T> event;
  final Widget Function(Event<T> event, bool isPast)? buildCard;

  @override
  _EventCardState<T> createState() => _EventCardState();
}

class _EventCardState<T> extends State<EventCard<T>> {
  late Timer _timer;
  final ValueNotifier<DateTime> _now = ValueNotifier(DateTime.now());

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _now.value = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _now.value = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _now,
      builder: (context, v, child) {
        final _current = DateTime(v.year, v.month, v.day, v.hour, v.minute);
        final bool _isPast = _current.isAfter(widget.event.end);

        return Positioned(
          top: widget.position.top,
          left: widget.position.left,
          child: Container(
            decoration: widget.buildCard == null
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _isPast
                        ? Colors.grey.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.3),
                  )
                : null,
            height: widget.position.height,
            width: widget.position.width,
            child: widget.buildCard != null
                ? widget.buildCard!(widget.event, _isPast)
                : ClipRRect(
                    child: Column(
                      children: [
                        // Text(
                        //   '${widget.event.start.format('hh:mm')} - ${widget.event.end.format('hh:mm')}',
                        //   style: const TextStyle(fontSize: 12),
                        // ),
                        // Text(
                        //   widget.event.date.format('yy:MM:dd'),
                        //   style: const TextStyle(fontSize: 12),
                        // ),
                        Text(
                          'is past: $_isPast',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
