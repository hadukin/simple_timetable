import 'package:example/models/event.dart';
import 'package:flutter/material.dart';
import 'package:simple_timetable/simple_timetable.dart';
import 'package:dart_date/dart_date.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple timetable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _month = DateTime.now();
  DateTime _initDate = DateTime.now();
  int visibleRange = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_month != null
            ? '${_month.year}-${_month.month}-${_month.day}'
            : ''),
        actions: [],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            child: Row(
              children: [
                SizedBox(width: 24),
                ElevatedButton(
                  child: Text('Change visible range'),
                  onPressed: () {
                    setState(() {
                      visibleRange = visibleRange == 7 ? 3 : 7;
                    });
                  },
                ),
                SizedBox(width: 24),
                ElevatedButton(
                  child: Text('Change initial date '),
                  onPressed: () {
                    setState(() {
                      _initDate = DateTime.now().addMonths(1);
                    });
                  },
                ),
                SizedBox(width: 24),
              ],
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: SimpleTimetable<TimeTableEvent>(
              onChange: (
                List<DateTime> current,
                TimetableDirection dir,
              ) {
                print('On change date: ${current[0]}');
                print('On change direction: $dir');
                print('On change columns $current');
                setState(() {
                  _month = current[0];
                });
              },
              initialDate: _initDate,
              dayStart: 8,
              dayEnd: 24,
              visibleRange: visibleRange,
              events: eventsList,
              buildCard: (event, isPast) {
                return GestureDetector(
                  onTap: () {
                    print(event.payload.data.title);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                      color: isPast
                          ? Colors.grey[400]
                          : Colors.blue[200].withOpacity(0.5),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${event.payload.data.title}',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          '${event.start.format('hh:mm')}\n${event.end.format('hh:mm')}',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          'isPast: $isPast',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<Event<TimeTableEvent>> eventsList = [
  Event<TimeTableEvent>(
    id: UniqueKey().toString(),
    start: DateTime.now().startOfDay.add(Duration(hours: 9)),
    end: DateTime.now().startOfDay.add(Duration(hours: 10)),
    date: DateTime.now().startOfDay,
    payload: TimeTableEvent(
      data: EventPayload(title: 'Event 1'),
    ),
  ),
  Event<TimeTableEvent>(
    id: UniqueKey().toString(),
    start: DateTime.now().startOfDay.add(Duration(hours: 12)),
    end: DateTime.now().startOfDay.add(Duration(hours: 13, minutes: 45)),
    date: DateTime.now().startOfDay,
    payload: TimeTableEvent(
      data: EventPayload(title: 'Event 2'),
    ),
  ),
  Event<TimeTableEvent>(
    id: UniqueKey().toString(),
    start: DateTime.now().startOfDay.add(Duration(hours: 11)),
    end: DateTime.now().startOfDay.add(Duration(hours: 12, minutes: 18)),
    date: DateTime.now().startOfDay,
    payload: TimeTableEvent(
      data: EventPayload(title: 'Event 3'),
    ),
  ),
  Event<TimeTableEvent>(
    id: UniqueKey().toString(),
    start: DateTime.now().startOfDay.add(Duration(hours: 15)),
    end: DateTime.now().startOfDay.add(Duration(hours: 16, minutes: 30)),
    date: DateTime.now().startOfDay,
    payload: TimeTableEvent(
      data: EventPayload(title: 'Event 3'),
    ),
  ),
  Event<TimeTableEvent>(
    id: UniqueKey().toString(),
    start: DateTime.now().startOfDay.add(
          Duration(
            days: 1,
            hours: 9,
          ),
        ),
    end: DateTime.now().startOfDay.add(
          Duration(
            days: 1,
            hours: 10,
            minutes: 15,
          ),
        ),
    date: DateTime.now().startOfDay.add(Duration(days: 1)),
    payload: TimeTableEvent(
      data: EventPayload(title: 'Event 4'),
    ),
  ),
  Event<TimeTableEvent>(
    id: UniqueKey().toString(),
    start: DateTime.now().startOfDay.add(
          Duration(
            days: 1,
            hours: 9,
          ),
        ),
    end: DateTime.now().startOfDay.add(
          Duration(
            days: 1,
            hours: 10,
            minutes: 15,
          ),
        ),
    date: DateTime.now().startOfDay.add(Duration(days: 1)),
    payload: TimeTableEvent(
      data: EventPayload(title: 'Event 5'),
    ),
  ),
  Event<TimeTableEvent>(
    id: UniqueKey().toString(),
    start: DateTime.now().startOfDay.add(
          Duration(
            days: 2,
            hours: 10,
          ),
        ),
    end: DateTime.now().startOfDay.add(
          Duration(
            days: 2,
            hours: 11,
            minutes: 30,
          ),
        ),
    date: DateTime.now().startOfDay.add(Duration(days: 2)),
    payload: TimeTableEvent(
      data: EventPayload(title: 'Event 6'),
    ),
  ),
];
