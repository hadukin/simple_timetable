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
    DateTime _now = start ?? Date.startOfToday;
    return List.generate(
        this.visibleRange, (index) => _now + Duration(days: index));
  }

  Map<DateTime, List<DateTime>> getTable([DateTime start]) {
    DateTime _now = start ?? Date.startOfToday;
    List<DateTime> timetable = _getTimetable(start: _now.startOfDay);
    Map<DateTime, List<DateTime>> table = {};

    timetable.forEach((day) {
      table.putIfAbsent(day, () => getTimeLineForDay(day));
    });
    return table;
  }

  List<DateTime> getTimeLineForDay([DateTime day]) {
    DateTime _day = day ?? Date.startOfToday;
    return List.generate(this.dayEndTime - this.dayStartTime, (index) {
      return _day.setHour(index + this.dayStartTime);
    });
  }
}
