import 'package:first_from_zero/models/RouteModel.dart';
import 'package:first_from_zero/models/SeatModel.dart';

class GlobalData {
  static RouteModel currentlySelected;
  static bool userHasAnAccount = false;
  static bool userIsLoggedIn = false;
  static List<SeatModel> selectedToBook = List.empty(growable: true), toAdd = List.empty(growable: true),
      toRemove = List.empty(growable: true),priceChanged=List.empty(growable: true);
}
