import 'package:simple_timetable/simple_timetable.dart';
import 'package:simple_timetable/src/extensions.dart';

List<Event<T>> _normalizeEvent<T>(List<Event<T>> data) {
  final result = data.map(
    (event) {
      final start = DateTime(
        event.start.year,
        event.start.month,
        event.start.day,
        event.start.hour,
        event.start.minute,
      );
      final end = DateTime(
        event.end.year,
        event.end.month,
        event.end.day,
        event.end.hour,
        event.end.minute,
      );
      final date = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
        event.date.hour,
        event.date.minute,
      );
      return Event<T>(
        id: event.id,
        start: start,
        end: end,
        date: date,
        payload: event.payload,
      );
    },
  ).toList();
  return result;
}

Future<Map<DateTime, List<List<Event<T>>>>> getGroups<T>(
  List<Event<T>> data,
) async {
  final _data = _normalizeEvent(data);

  _data.sort((a, b) => a.start.compareTo(b.start));

  final Map<DateTime, List<Event<T>>> groups = {};
  final Map<DateTime, List<List<Event<T>>>> _grouped = {};

  for (final item in _data) {
    if (!groups.containsKey(item.date.startOfDay)) {
      groups[item.date.startOfDay] = [item];
    } else {
      groups[item.date.startOfDay] = [item, ...groups[item.date.startOfDay]!];
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
  final Map<int?, List<Event<T>>> temp = {};
  int? enterGroup;

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
      final a1 = period.start.compareTo(testPeriod.start) <= 0;
      final a2 = period.end.compareTo(testPeriod.start) >= 0;
      final b1 = period.start.compareTo(testPeriod.start) >= 0;
      final b2 = period.start.compareTo(testPeriod.end) <= 0;
      if ((a1 && a2) || (b1 && b2)) return true;
    }
  }
  return false;
}
