import 'package:flutter/material.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({
    Key key,
    @required this.offsetTop,
    @required this.timelineColumnWidth,
    @required this.horizontalIndent,
  }) : super(key: key);
  final double offsetTop;
  final double timelineColumnWidth;
  final double horizontalIndent;

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _width = _w - timelineColumnWidth - 4 - (horizontalIndent * 2);

    // TODO: create current time
    // String _pattern = 'H:mm';
    // String _time = DateFormat(_pattern).format(DateTime.now());

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
          SizedBox(width: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blue[400],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            width: _width,
            height: 2,
            color: Colors.blue[400],
          ),
        ],
      ),
    );
  }
}
