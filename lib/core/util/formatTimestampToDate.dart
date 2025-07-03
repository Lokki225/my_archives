import 'package:intl/intl.dart';

/// Utility function to convert an integer timestamp to a formatted string date.
String formatTimestampToDate(int timestamp, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
  // Convert the timestamp to a DateTime object
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // Use the DateFormat from the intl package to format the date
  return DateFormat(format).format(dateTime);
}
