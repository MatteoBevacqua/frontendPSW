import 'package:first_from_zero/models/RouteModel.dart';
import 'package:first_from_zero/models/SeatModel.dart';

class GlobalData {
  static RouteModel currentlySelected;
  static bool userHasAnAccount = false;
  static bool userIsLoggedIn = false;
  static List<SeatModel> selectedToBook = List.empty(growable: true);
}
