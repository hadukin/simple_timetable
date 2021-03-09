import 'package:simple_timetable/src/extensions.dart';

class TimetableHelper {
  final int? dayStartTime;
  final int? dayEndTime;
  final int? visibleRange;

  TimetableHelper({
    this.dayStartTime = 0,
    this.dayEndTime = 24,
    this.visibleRange = 7,
  });

  List<DateTime> _getTimetable({required DateTime start}) {
    final DateTime _now = start;

    return List.generate(
        visibleRange!, (index) => _now.add(Duration(days: index)));
  }

  Map<DateTime, List<DateTime>> getTable([DateTime? start]) {
    final DateTime _now = start ?? DateTime.now().startOfDay;

    final List<DateTime> timetable = _getTimetable(start: _now.startOfDay);
    final Map<DateTime, List<DateTime>> table = {};

    for (final day in timetable) {
      table.putIfAbsent(day, () => getTimeLineForDay(day));
    }

    return table;
  }

  List<DateTime> getTimeLineForDay([DateTime? day]) {
    final DateTime _day = day ?? DateTime.now().startOfDay;

    return List.generate(dayEndTime! - dayStartTime!, (index) {
      return _day.startOfDay.addHour(index + dayStartTime!);
    });
  }
}
