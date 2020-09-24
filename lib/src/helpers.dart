import 'package:simple_timetable/simple_timetable.dart';
import 'package:dart_date/dart_date.dart';

Future<Map<DateTime, Map<int, List<Event>>>> getGroups(
  List<Event> data,
) async {
  Map<DateTime, Map<int, List<Event>>> _groups = {};
  data.forEach((item) {
    if (!_groups.containsKey(item.date.startOfDay)) {
      _groups[item.date.startOfDay] = {
        item.start.hour: [item],
      };
    } else {
      if (!_groups[item.date.startOfDay].containsKey(item.start.hour)) {
        _groups[item.date.startOfDay][item.start.hour] = [item];
      } else {
        _groups[item.date.startOfDay][item.start.hour] = [
          ..._groups[item.date.startOfDay][item.start.hour],
          item
        ];
      }
    }
  });
  return _groups;
}
