import 'dart:convert';
import 'package:example/models/event.dart';
import 'package:example/models/table_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_timetable/simple_timetable.dart';
import 'package:intl/intl.dart';
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
  List<Event<TimeTableEvent>> _events = [];

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
    List<TimeTableEvent> data = await _getTimetable(query.params);
    List<Event<TimeTableEvent>> _data = data
        .map((item) => Event<TimeTableEvent>(
              id: UniqueKey().toString(),
              date: item.startDate,
              start: Date.parse(item.data.eventStart),
              end: Date.parse(item.data.eventEnd),
              payload: item,
            ))
        .toList();
    setState(() {
      _events.addAll(_data);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_month != null ? '$_month' : '')),
      body: SimpleTimetable(
        onChange: (
          DateTime date,
          TimetableDirection dir,
          List<DateTime> current,
        ) {
          print('On change date: $date');
          print('On change direction: $dir');
          print('On change columns $current');
          setState(() {
            _month = date;
          });
        },
        initialDate: _initDate.startOfDay,
        dayStart: 8,
        dayEnd: 24,
        events: _events,
        buildCard: (Event event, bool isPast) {
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
                    '${event.start.format('hh:mm')}\n${event.end.format('hh:mm')}',
                    style: TextStyle(fontSize: 10),
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
