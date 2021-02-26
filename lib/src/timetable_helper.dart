import 'package:dart_date/dart_date.dart';

class TimetableHelper {
  final int dayStartTime;
  final int dayEndTime;
  final int visibleRange;

  TimetableHelper({
    this.dayStartTime = 0,
    this.dayEndTime = 24,
    this.visibleRange = 7,
  });

  List<DateTime> _getTimetable({DateTime start}) {
    final DateTime _now = start ?? Date.startOfToday;
    return List.generate(visibleRange, (index) => _now + Duration(days: index));
  }

  Map<DateTime, List<DateTime>> getTable([DateTime start]) {
    final DateTime _now = start ?? Date.startOfToday;
    final List<DateTime> timetable = _getTimetable(start: _now.startOfDay);
    final Map<DateTime, List<DateTime>> table = {};

    for (final day in timetable) {
      table.putIfAbsent(day, () => getTimeLineForDay(day));
    }

    return table;
  }

  List<DateTime> getTimeLineForDay([DateTime day]) {
    final DateTime _day = day ?? Date.startOfToday;
    return List.generate(dayEndTime - dayStartTime, (index) {
      return _day.setHour(index + dayStartTime);
    });
  }
}
