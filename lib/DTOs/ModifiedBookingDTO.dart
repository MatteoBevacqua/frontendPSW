import 'package:first_from_zero/models/Reservation.dart';
import 'package:first_from_zero/models/SeatModel.dart';

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
