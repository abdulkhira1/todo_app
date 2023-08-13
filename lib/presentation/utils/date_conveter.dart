import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime time) {
    return DateFormat('MMM dd, yyyy').format(time);
  }

  static DateTime stringTodateTime(String date) {
    DateTime parseDate = DateFormat('MMM dd, yyyy').parse(date);
    var dateTime = DateTime.parse(parseDate.toString());
    return dateTime;
  }

  static String checkDateGroup(String date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    DateTime parseDate = DateFormat('MMM dd, yyyy').parse(date);
    var dateToCheck = DateTime.parse(parseDate.toString());
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (aDate == today) {
      return "Today";
    } else if (aDate == yesterday) {
      return "Completed";
    } else if (aDate == tomorrow) {
      return "Tomorrow";
    }
    return "Upcoming";
  }
}
