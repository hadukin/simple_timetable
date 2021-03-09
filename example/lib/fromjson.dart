// List<Event<TimeTableEvent>> data = [];

// @override
// void initState() {
//   super.initState();
//   getFileData('assets/data.json');
// }

// Future<void> getFileData(String path) async {
//   final result = await rootBundle.loadString(path);
//   final dynamic response = json.decode(result);

//   for (var item in response['events']) {
//     final start = Date.parse(item['eventStart'] as String);
//     final end = Date.parse(item['eventEnd'] as String);
//     final date = Date.parse(item['eventDate'] as String);

//     final event = Event<TimeTableEvent>(
//       id: UniqueKey().toString(),
//       start: start,
//       end: end,
//       date: date,
//       payload: TimeTableEvent(
//         data: EventPayload(title: item['title'] as String),
//       ),
//     );

//     data.add(event);
//   }

//   setState(() {
//     data = data;
//   });
// }
