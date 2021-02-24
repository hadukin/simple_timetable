import 'package:simple_timetable/simple_timetable.dart';
import 'package:dart_date/dart_date.dart';

Future<Map<DateTime, List<List<Event<T>>>>> getGroups<T>(
  List<Event<T>> data,
) async {
  data.sort((a, b) => a.start.compareTo(b.start));
  final Map<DateTime, List<Event<T>>> groups = {};
  final Map<DateTime, List<List<Event<T>>>> _grouped = {};

  for (final item in data) {
    if (!groups.containsKey(item.date.startOfDay)) {
      groups[item.date.startOfDay] = [item];
    } else {
      groups[item.date.startOfDay] = [item, ...groups[item.date.startOfDay]];
    }
  }

  for (final item in groups.entries) {
    _grouped[item.key] = _getSortByOverlap(
      item.value..sort((a, b) => a.start.compareTo(b.start)),
    );
  }

  return _grouped;
}

List<List<Event<T>>> _getSortByOverlap<T>(List<Event<T>> data) {
  final List<Event<T>> current = [];
  final List<bool> isOverlap = [];
  final List<bool> isOverlapCount = [];
  final List<List<Event<T>>> groupedEvents = [];
  final Map<int, List<Event<T>>> temp = {};
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

bool _periodOverlaps<T>(Event<T> testPeriod, List<Event<T>> periods) {
  for (var i = 0; i < periods.length; i++) {
    final period = periods[i];
    if (period.id != testPeriod.id) {
      if (period.start <= testPeriod.start && period.end > testPeriod.start) {
        return true;
      }
      if (period.start >= testPeriod.start && period.start < testPeriod.end) {
        return true;
      }
    }
  }
  return false;
}
