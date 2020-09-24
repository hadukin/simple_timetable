import 'dart:convert';
import 'package:example/models/table_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_timetable/simple_timetable.dart';
import 'package:intl/intl.dart';
import 'models/event.dart';
import 'package:dart_date/dart_date.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
  DateTime month = DateTime.now();
  List<Event<TimeTableEvent>> _arrayEvents = [];
  List<DateTime> _datesList = [];
  bool _isLoading = false;
  DateTime _initDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    TableQuery query = getQuery();
    getData(query);
  }

  Future<List<TimeTableEvent>> _getTimetable([String query]) async {
    var dataString = await rootBundle.loadString('assets/data.json');
    var data = json.decode(dataString);
    List<TimeTableEvent> _events = (data['events'] as List)
        .map((item) => TimeTableEvent.fromJson(item))
        .toList();
    return _events;
  }

  void getData(TableQuery query) async {
    if (!_isLoading) {
      List<DateTime> _newDates = getDatesList(
        start: query.start,
        end: query.end,
      );

      List<TimeTableEvent> _listEvents = await _getTimetable(query.params);
      // List<Event<TimeTableEvent>> _arr = eventCreator(_listEvents);
      List<Event<TimeTableEvent>> _arr = _listEvents
          .map(
            (item) => Event<TimeTableEvent>(
              date: item.startDate,
              start: Date.parse(item.payload.eventStart),
              end: Date.parse(item.payload.eventEnd),
              payload: item,
            ),
          )
          .toList();

      setState(() {
        _arrayEvents.addAll(_arr);
        _datesList.addAll(_newDates);
      });
    }
  }

  List<DateTime> getDatesList({DateTime start, DateTime end}) {
    DateTime _start = start ?? DateTime.now();
    DateTime _end = end ?? _start.addWeeks(1);
    int _diff = _start.differenceInDays(_end).abs() + 1;
    List<DateTime> _list = List.generate(
        _diff, (index) => (_start + Duration(days: index)).startOfDay);
    return _list;
  }

  TableQuery getQuery({DateTime start, DateTime end}) {
    String _pattern = 'yyyy-MM-dd';
    DateTime _start = start ?? Date.startOfToday;
    DateTime _end = end ?? _start.addDays(6);
    String _startString = DateFormat(_pattern).format(_start);
    String _endString = DateFormat(_pattern).format(_end);
    String _query = 'start=$_startString&end=$_endString';
    return TableQuery(params: _query, start: _start, end: _end);
  }

  _onPressed([DateTime start, DateTime end]) async {
    setState(() {
      _initDate = DateTime.now().addMonths(1);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(month != null ? '$month' : ''),
      ),
      drawer: Drawer(),
      body: SimpleTimetable(
        onChange: (DateTime date, TimetableDirection dir) {
          print('On change date: $date');
          print('On change direction: $dir');
          setState(() {
            month = date;
          });
        },
        initialDate: _initDate.startOfDay,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressed,
      ),
    );
  }
}
