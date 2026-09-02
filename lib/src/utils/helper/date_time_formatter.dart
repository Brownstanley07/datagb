import 'package:intl/intl.dart';

class DateTimeFormatter {
  //date formatter
  String formatDate(String date) {
    DateTime parsed = DateFormat("MMM dd yyyy HH:mm").parse(date);
    return "${parsed.day} "
        "${_monthShortName(parsed.month)} "
        "${parsed.year}";
  }

  String _monthShortName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  //time formatter
  String formatTime(String time) {
    DateTime parsed = DateFormat("MMM dd yyyy HH:mm").parse(time);
    int hour = parsed.hour;
    int minute = parsed.minute;
    String ampm = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')} $ampm";
  }
}
