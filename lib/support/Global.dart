import 'package:frontendpsw/models/Reservation.dart';
import 'package:frontendpsw/models/RouteModel.dart';
import 'package:frontendpsw/models/SeatModel.dart';

class GlobalData {
  static RouteModel currentlySelected;
  static int subtotal = 0, modifyingSubtotal = 0;
  static bool userHasAnAccount = false;
  static bool userIsLoggedIn = false;
  static Set<SeatModel> selectedToBook = Set(),
      toAdd = Set(),
      toRemove = Set(),
      priceChanged = Set(),
      currentBooking = Set();
  static Reservation currentRes;

  static Observer observer = Observer();

  static void clearBookingData() {
    selectedToBook.clear();
  }
}

class Subject {
  void notifyObserver() {
    GlobalData.observer.update();
  }
}

class Stalker {
  void receiveUpdate() {}
}

class Observer {
  Set<Stalker> endUsers = Set();

  void update() {
    int temp = 0, temp1 = 0;
    for (SeatModel model in GlobalData.selectedToBook) temp += model.pricePaid;
    GlobalData.subtotal = temp;
    for (SeatModel model in GlobalData.currentBooking) temp1 += model.pricePaid;
    GlobalData.modifyingSubtotal = temp1;
    endUsers.forEach((element) {
      element.receiveUpdate();
    });
  }

  void addStalker(Stalker stalker) {
    endUsers.add(stalker);
  }
}
