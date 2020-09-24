import 'package:example/models/event.dart';
import 'package:simple_timetable/simple_timetable.dart';
import 'package:dart_date/dart_date.dart';

List<Event<TimeTableEvent>> eventCreator(List<TimeTableEvent> listEvents) {
  List<Event<TimeTableEvent>> _events = listEvents.map((item) {
    int startHour = int.parse(item.data.eventStart.split(':')[0]);
    int startMinutes = int.parse(item.data.eventStart.split(':')[1]);
    int endHour = int.parse(item.data.eventEnd.split(':')[0]);
    int endMinutes = int.parse(item.data.eventEnd.split(':')[1]);

    DateTime updateStart =
        item.startDate.addHours(startHour).addMinutes(startMinutes);
    DateTime updateEnd =
        item.startDate.addHours(endHour).addMinutes(endMinutes);

    print(updateStart);

    return Event(
      date: item.startDate.startOfDay,
      start: updateStart,
      end: updateEnd,
      payload: item,
    );
  }).toList();
  return _events;
}
