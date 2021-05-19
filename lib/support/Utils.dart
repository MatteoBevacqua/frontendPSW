import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime dateTime) {
    return DateFormat.yMMMMEEEEd().format(dateTime).toString() +
        "  " +
        DateFormat.Hm().format(dateTime).toString();
  }
}
