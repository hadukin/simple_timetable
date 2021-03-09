extension DateTimeX on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  DateTime addHour(int value) {
    return DateTime(year, month, day, hour + value);
  }

  DateTime subHour(int value) {
    return DateTime(year, month, day, hour - value);
  }

  DateTime addDay(int value) {
    return DateTime(year, month, day + value);
  }

  DateTime subDay(int value) {
    return DateTime(year, month, day - value);
  }

  bool get isToday => DateTime.now().startOfDay.compareTo(this) == 0;
}
