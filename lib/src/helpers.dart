import 'package:simple_timetable/simple_timetable.dart';
import 'package:dart_date/dart_date.dart';

Future<Map<DateTime, List<List<Event>>>> getGroups(
  List<Event> data,
) async {
  data..sort((a, b) => a.start.compareTo(b.start));

  Map<DateTime, List<Event>> groups = {};

  data.forEach((item) {
    if (!groups.containsKey(item.date.startOfDay)) {
      groups[item.date.startOfDay] = [item];
    } else {
      groups[item.date.startOfDay] = [item, ...groups[item.date.startOfDay]];
    }
  });

  Map<DateTime, List<List<Event>>> _grouped = {};

  groups.entries.forEach((item) {
    _grouped[item.key] = _getSortByOverlap(
      item.value..sort((a, b) => a.start.compareTo(b.start)),
    );
  });

  return _grouped;
}

List<List<Event>> _getSortByOverlap(List<Event> data) {
  List<Event> current = [];
  List<dynamic> isOverlap = [];
  List<dynamic> isOverlapCount = [];
  List<List<Event>> groupedEvents = [];
  Map<int, List<Event>> temp = {};
  int enterGroup;

  for (var i = 0; i < data.length; i++) {
    final item = data[i];
    current.add(item);
    isOverlap.add(_periodOverlaps(item, data));
    isOverlapCount.add(_periodOverlaps(item, current));
  }

  for (var i = 0; i < data.length; i++) {
    if (isOverlap[i] == true) {
      if (isOverlapCount[i] == false) {
        enterGroup = i;
        temp[i] = [data[i]];
      } else {
        temp[enterGroup] = [...?temp[enterGroup], data[i]];
      }
    } else {
      groupedEvents.add([data[i]]);
    }
  }

  groupedEvents.addAll(temp.values);
  return groupedEvents;
}

_periodOverlaps(Event testPeriod, List<Event> periods) {
  for (var i = 0; i < periods.length; i++) {
    final period = periods[i];
    if (period.id != testPeriod.id) {
      if (period.start <= testPeriod.start && period.end > testPeriod.start)
        return true;
      if (period.start >= testPeriod.start && period.start < testPeriod.end)
        return true;
    }
  }
  return false;
}
