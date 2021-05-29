import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime dateTime) {
    return DateFormat.yMMMMEEEEd().format(dateTime).toString() +
        "  " +
        DateFormat.Hm().format(dateTime).toString();
  }

}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension CustomAdd<T> on Set<T>{
  void forceAdd(T element){
    this.remove(element);
    this.add(element);
  }
}