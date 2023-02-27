import 'package:flutter/foundation.dart';

final List month = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

final List weekday = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

class DateTimeConverter {
  getDateNum(DateTime date) {
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    int months = date.month;
    return '$day-$months-${date.year}';
  }

  getRawDateNum(DateTime date) {
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    String months = date.month < 10 ? "0${date.month}" : "${date.month}";
    return '${date.year}-$months-$day';
  }

  getDateName(DateTime date) {
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    int months = date.month;
    return '$day ${month[months - 1]}, ${date.year}';
  }

  getTime(DateTime date) {
    String hour = date.hour == 0
        ? '12'
        : date.hour < 10
            ? "0${date.hour}"
            : date.hour < 12
                ? "${date.hour}"
                : "${date.hour - 12}";
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    String amPm = date.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $amPm';
  }

  getRawTime(DateTime date) {
    String hour = date.hour < 10 ? "0${date.hour}" : date.hour.toString();
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    return '$hour:$minute';
  }

  String formatSeconds(int seconds) {
    if (seconds == 0) {
      return "00";
    }
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    seconds = seconds % 60;

    String formattedTime = "";
    if (hours > 0) {
      formattedTime += "${hours.toString().padLeft(2, '0')}:";
    }
    formattedTime += "${minutes.toString().padLeft(2, '0')}:";
    formattedTime += seconds.toString().padLeft(2, '0');

    return formattedTime;
  }

  String secondToHoursMin(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    String formattedDuration = '';
    if (hours > 0) {
      formattedDuration += '$hours hr ';
    }
    formattedDuration += '$minutes mins';
    return formattedDuration;
  }
}
