import 'package:first_from_zero/models/Reservation.dart';
import 'package:first_from_zero/models/RouteModel.dart';
import 'package:first_from_zero/models/SeatModel.dart';

class GlobalData {
  static RouteModel currentlySelected;
  static bool userHasAnAccount = false;
  static bool userIsLoggedIn = false;
  static Set<SeatModel> selectedToBook = Set(), toAdd = Set(),
      toRemove = Set(),priceChanged=Set();
  static Reservation currentRes;
  static Set<SeatModel> currentBooking;
  static void clearBookingData() {
    selectedToBook.clear();
  }
}
