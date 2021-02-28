import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({
    Key? key,
    required this.offsetTop,
    required this.timelineColumnWidth,
    required this.horizontalIndent,
    this.color,
  }) : super(key: key);
  final double offsetTop;
  final double timelineColumnWidth;
  final double horizontalIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final double _w = MediaQuery.of(context).size.width;
    final double _width = _w - timelineColumnWidth - 4 - (horizontalIndent * 2);

    // TODO: create current time
    // String _pattern = 'H:mm';
    // final String _time = DateFormat(_pattern).format(DateTime.now());

    return Positioned(
      right: 0,
      top: offsetTop,
      child: Row(
        children: [
          // TODO: create current time
          // Container(
          //   child: Text(
          //     _time,
          //     style: TextStyle(fontSize: 10, color: Colors.red),
          //   ),
          // ),
          const SizedBox(width: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color ?? Colors.blue[400],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            width: _width,
            height: 2,
            color: color ?? Colors.blue[400],
          ),
        ],
      ),
    );
  }
}
