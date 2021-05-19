import 'package:first_from_zero/models/RouteModel.dart';

import 'Passenger.dart';

class Reservation {
  int id;
  Passenger passenger;
  RouteModel bookedRoute;
  DateTime reservationBookingDate;

  Reservation(
      {this.id, this.passenger, this.bookedRoute, this.reservationBookingDate});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    var res = Reservation(
        id: json['id'],
        passenger: Passenger.fromJson(json['passenger']),
        bookedRoute: RouteModel.fromJson(json['bookedRoute']),
        reservationBookingDate: DateTime.parse(json['reservationBookingDate']));
    print(res.id);
    print(res.passenger.toJson().toString());
    print(res.bookedRoute.toJson().toString());
    print(res.reservationBookingDate);
    return res;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'passenger': passenger,
        'bookedRoute': bookedRoute.toJson(),
        'reservationBookingDate': reservationBookingDate.toIso8601String()
      };

  String toString() {
    return this.toJson().toString();
  }
}
