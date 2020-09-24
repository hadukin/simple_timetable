# simple_timetable

Simple timetable.

## Getting Started

##### Event model

```
class Event<T> {
  final DateTime start;
  final DateTime end;
  final DateTime date;
  final T payload;

  Event({
    this.start,
    this.end,
    this.date,
    this.payload,
  });
}
```

##### Create list events

```
final List<Event> _events = [
  Event(
    date: Date.parse("2020-09-24T00:00:00Z"),
    start: Date.parse("2020-09-24T10:00:00Z"),
    end: Date.parse("2020-09-24T10:45:00Z"),
  ),
  Event(
    date: Date.parse("2020-09-24T00:00:00Z"),
    start: Date.parse("2020-09-24T10:30:00Z"),
    end: Date.parse("2020-09-24T11:15:00Z"),
  ),
  Event(
    date: Date.parse("2020-09-25T00:00:00Z"),
    start: Date.parse("2020-09-25T10:00:00Z"),
    end: Date.parse("2020-09-25T11:00:00Z"),
  ),
];
```

##### Usage

```
Widget build(BuildContext context) {
  return Scaffold(
    body: SimpleTimetable(
      onChange: (DateTime date, TimetableDirection dir) {
        print('On change date: $date');
        print('On change direction: $dir');
      },
      initialDate: DateTime.now(),
      dayStart: 8,
      dayEnd: 24,
      events: _events,
      buildCard: (Event event, bool isPast) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.blue.withOpacity(0.3),
            ),
            child: Column(
              children: [
                Text(
                  '$isPast',
                  maxLines: 1,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
```
