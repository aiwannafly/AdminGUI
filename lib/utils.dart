import 'package:flutter/material.dart';

TimeOfDay timeOfDayFromStr(String timeOfDay) {
  List<int> hourMinuteSecond =
      timeOfDay.split(':').map((e) => int.parse(e)).toList();
  return TimeOfDay(hour: hourMinuteSecond[0], minute: hourMinuteSecond[1]);
}

String timeOfDayToStr(TimeOfDay timeOfDay) {
  String minPrefix = timeOfDay.minute < 10 ? "0" : "";
  return "${timeOfDay.hour}:$minPrefix${timeOfDay.minute}";
}

String dateTimeToStr(DateTime dateTime) {
  String monthPrefix = dateTime.month < 10 ? "0" : "";
  String dayPrefix = dateTime.day < 10 ? "0" : "";
  return "${dateTime.year}-$monthPrefix${dateTime.month}-$dayPrefix${dateTime.day}";
}
