import 'dart:async';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:simple_timetable/simple_timetable.dart';
import 'package:simple_timetable/src/event.dart';
import 'package:simple_timetable/src/events_create.dart';
import 'package:simple_timetable/src/helpers.dart';
import 'package:simple_timetable/src/timeline.dart';
import 'package:simple_timetable/src/timetable_helper.dart';
import 'package:intl/intl.dart';

class SimpleTimetable<T> extends StatefulWidget {
  const SimpleTimetable({
    Key key,
    @required this.initialDate,
    @required this.events,
    this.cellHeight = 60,
    this.timelineColumnWidth = 50,
    this.horizontalIndent = 24,
    this.buildHeader,
    this.buildCell,
    this.buildCard,
    this.onChange,
    this.dayStart = 8,
    this.dayEnd = 20,
    this.visibleRange = 7,
    this.colorTimeline,
    this.prevBotton,
    this.nextBotton,
  })  : assert(initialDate != null),
        assert(dayStart < dayEnd),
        assert(dayEnd > dayStart),
        assert(dayStart >= 0 && dayStart <= 23),
        assert(dayEnd > 0 && dayEnd <= 24),
        super(key: key);
  final Color colorTimeline;
  final List<Event<T>> events;
  final double cellHeight;
  final double timelineColumnWidth;
  final double horizontalIndent;
  final int visibleRange;
  final int dayStart;
  final int dayEnd;
  final DateTime initialDate;
  final Function(
    List<DateTime> currentColumns,
    TimetableDirection dir,
  ) onChange;
  final Widget Function(Event<T> event, bool isPast) buildCard;
  final Widget Function(bool isFirstColumn, bool isLastColumn) buildCell;
  final Widget Function(DateTime date, bool isToday) buildHeader;
  final Widget prevBotton;
  final Widget nextBotton;

  @override
  SimpleTimetableState<T> createState() => SimpleTimetableState();
}

class SimpleTimetableState<T> extends State<SimpleTimetable<T>> {
  Timer _timer;
  double _dragDirection = 0;
  List<DateTime> _timeLine = [];
  TimetableHelper _timetableHelper;
  Map<DateTime, List<DateTime>> _columns = {};
  Map<DateTime, List<List<Event<T>>>> _groups = {};
  final ValueNotifier<double> _timeLinePosition = ValueNotifier(0.0);

  @override
  void didUpdateWidget(SimpleTimetable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate.startOfDay != widget.initialDate.startOfDay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _createTable(
          start: widget.initialDate ?? DateTime.now(),
          dir: TimetableDirection.none,
        );
      });
    }
    if (widget.events.isNotEmpty) {
      getGroups<T>(widget.events).then(
        (value) {
          setState(() {
            _groups = value;
          });
        },
      ).catchError((dynamic e) {
        // ignore: avoid_print
        print('GET GROUPS ERROR\n$e');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();

    _timelinePosition();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _timelinePosition();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createTable(
        start: widget.initialDate ?? DateTime.now(),
        dir: TimetableDirection.none,
      );
    });
  }

  void _timelinePosition() {
    final _t = widget.cellHeight / 60;
    final _todayStart = Date.today.startOfDay.addHours(widget.dayStart);
    final _now = DateTime.now();
    var _diff = _todayStart.differenceInMinutes(_now).abs();
    if (_todayStart.differenceInMinutes(_now) < 0) {
      _diff = _todayStart.differenceInMinutes(_now).abs();
    } else {
      _diff = 0;
    }
    _timeLinePosition.value = _diff * _t;
  }

  void _createTable({DateTime start, TimetableDirection dir}) {
    _timetableHelper = TimetableHelper(
      dayStartTime: widget.dayStart,
      dayEndTime: widget.dayEnd,
      visibleRange: widget.visibleRange,
    );
    _columns = _timetableHelper.getTable(start);
    _timeLine = _timetableHelper.getTimeLineForDay(start);
    // TODO: start will be deprecated
    widget.onChange(_columns.keys.toList(), dir);
    setState(() {});
  }

  bool _getLastColumn(DateTime date) => _columns?.keys?.last == date;

  bool _getFirstColumn(DateTime date) => _columns?.keys?.first == date;

  BoxDecoration _cellDefaultStyle({bool isFirst, bool isLast}) => BoxDecoration(
        border: Border(
          top: const BorderSide(color: Color(0xffDEE2E8)),
          right: isLast
              ? BorderSide.none
              : const BorderSide(color: Color(0xffDEE2E8)),
        ),
      );

  Column _cell(MapEntry<DateTime, List<DateTime>> column) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...column.value.map(
          (elem) {
            final bool _isFirstColumn = _getFirstColumn(column.key);
            final bool _isLastColumn = _getLastColumn(column.key);
            return Container(
              decoration: widget.buildCell != null
                  ? null
                  : _cellDefaultStyle(
                      isFirst: _isFirstColumn,
                      isLast: _isLastColumn,
                    ),
              height: widget.cellHeight,
              child: widget.buildCell == null
                  ? null
                  : widget.buildCell(_isFirstColumn, _isLastColumn),
            );
          },
        ).toList()
      ],
    );
  }

  Widget _cellHeader(DateTime day, bool _isToday) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: _isToday ? Colors.blue[400] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          DateFormat("d").format(day),
          style: TextStyle(
            color: _isToday ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _prev(DateTime date) {
    if (widget.prevBotton != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _createTable(
            start: date.subDays(1),
            dir: TimetableDirection.backward,
          );
        },
        child: widget.prevBotton,
      );
    }
    return IconButton(
      onPressed: () {
        _createTable(
          start: date.subDays(1),
          dir: TimetableDirection.backward,
        );
      },
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black54,
      ),
    );
  }

  Widget _next(DateTime date) {
    if (widget.nextBotton != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _createTable(
            start: date.addDays(1),
            dir: TimetableDirection.forward,
          );
        },
        child: widget.nextBotton,
      );
    }
    return IconButton(
      onPressed: () {
        _createTable(
          start: date.addDays(1),
          dir: TimetableDirection.forward,
        );
      },
      icon: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.black54,
      ),
    );
  }

  Widget _eventsForColumn(MapEntry<DateTime, List<DateTime>> column) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = constraints.constrainWidth();
        List<Widget> eventWidgets;
        if (_groups.keys.contains(column.key)) {
          eventWidgets = eventsCreate<T>(
            dayStartFrom: widget.dayStart,
            events: _groups[column.key],
            cellHeight: widget.cellHeight,
            cellWidth: cellWidth,
            buildCard: widget.buildCard,
          );
        } else {
          eventWidgets = [const SizedBox.shrink()];
        }
        return Stack(
          children: [
            _cell(column),
            ...eventWidgets,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLine.isEmpty || _columns.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: widget.horizontalIndent,
            right: widget.horizontalIndent,
          ),
          child: Row(
            children: [
              SizedBox(
                width: widget.timelineColumnWidth,
                child: _prev(_columns?.keys?.first),
              ),
              ..._columns?.keys?.map(
                (day) {
                  final bool _isToday = day == Date.today.startOfDay;
                  return Expanded(
                    child: SizedBox(
                      height: 60,
                      child: Align(
                          child: _columns?.keys?.last == day
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (widget.buildHeader != null)
                                      widget.buildHeader(day, _isToday)
                                    else
                                      _cellHeader(day, _isToday),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: _next(_columns?.keys?.first),
                                    )
                                  ],
                                )
                              : widget.buildHeader != null
                                  ? widget.buildHeader(day, _isToday)
                                  : _cellHeader(day, _isToday)),
                    ),
                  );
                },
              )?.toList(),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              _dragDirection = details.primaryDelta;
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              if (_dragDirection < 0) {
                final DateTime _date = _columns?.keys?.first?.addDays(1);
                _createTable(start: _date, dir: TimetableDirection.forward);
              } else {
                final DateTime _date = _columns?.keys?.first?.subDays(1);
                _createTable(start: _date, dir: TimetableDirection.backward);
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  left: widget.horizontalIndent,
                  right: widget.horizontalIndent,
                ),
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: widget.timelineColumnWidth,
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ..._timeLine?.map(
                                    (item) {
                                      return Container(
                                        alignment: Alignment.topRight,
                                        decoration: const BoxDecoration(
                                          border: Border(),
                                        ),
                                        height: widget.cellHeight,
                                        child: Transform.translate(
                                          offset: const Offset(-8.0, -8.0),
                                          child: SizedBox(
                                            child: Text(
                                              DateFormat("H:00").format(item),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )?.toList()
                                ],
                              ),
                            ],
                          ),
                        ),
                        ..._columns?.entries?.map(
                          (column) {
                            return Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _eventsForColumn(column),
                                ],
                              ),
                            );
                          },
                        )?.toList()
                      ],
                    ),
                    if (_timeLinePosition.value != 0.0)
                      ValueListenableBuilder<double>(
                        valueListenable: _timeLinePosition,
                        builder: (
                          BuildContext context,
                          double value,
                          Widget child,
                        ) =>
                            TimeLine(
                          color: widget.colorTimeline,
                          offsetTop: _timeLinePosition.value,
                          timelineColumnWidth: widget.timelineColumnWidth,
                          horizontalIndent: widget.horizontalIndent,
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
