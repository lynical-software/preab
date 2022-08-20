import 'package:sura_flutter/sura_flutter.dart';

extension DT on DateTime {
  bool get isThisYear => year == DateTime.now().year;
}

bool isTheSameDayTS(int ts1, int ts2) {
  DateTime date1 = DateTime.fromMillisecondsSinceEpoch(ts1);
  DateTime date2 = DateTime.fromMillisecondsSinceEpoch(ts2);
  return date1.isTheSameDay(date2);
}

String formatDateTimeLabel(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  if (date.isTheSameDay(DateTime.now())) {
    return date.formatDate(format: "HH:mm");
  } else if (date.isThisYear) {
    return date.formatDate(format: "dd MMMM");
  }
  return date.formatDate(format: "dd MMM yyyy HH:mm");
}

String formatMessageDateFilter(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  if (date.isTheSameDay(DateTime.now())) {
    return "Today";
  } else if (date.isThisYear) {
    return date.formatDate(format: "dd MMMM");
  }
  return date.formatDate(format: "dd MMMM yyyy");
}

String formatMessageDateTime(DateTime? date) {
  if (date == null) return "";
  return date.formatDate(format: "HH:mm");
}
