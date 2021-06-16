import 'package:frontendpsw/models/Reservation.dart';
import 'package:frontendpsw/models/SeatModel.dart';

class CustomRes {
  int id;

  CustomRes({this.id});

  Map<String, dynamic> toJson() => {
  'id':id
  };
}

class ModifiedBookingDTO {
  Reservation toModify;
  List<SeatModel> toAdd,toRemove;

}
