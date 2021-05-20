import 'dart:convert';

import 'package:first_from_zero/models/RouteModel.dart';
import 'package:first_from_zero/models/SeatModel.dart';

import 'Passenger.dart';

class SeatDTO {
  SeatDTO({this.id});

  int id;

  Map<String, dynamic> toJson() => {'id': id};

  String toString() {
    return this.toJson().toString();
  }
}

class RouteDTO {
  RouteDTO({this.id});

  int id;

  Map<String, dynamic> toJson() => {'id': id};

  String toString() {
    return this.toJson().toString();
  }
}

class Reservation {
  int id;
  Passenger passenger;
  RouteModel bookedRoute;
  DateTime reservationBookingDate;
  List<SeatModel> reservedSeats;

  Map<String, dynamic> toPostableDTO() {
    Map<String, dynamic> params = Map();
    params['route'] = RouteDTO(id: this.bookedRoute.id).toJson();
    List<SeatDTO> seatDTOS =
        reservedSeats.map((e) => SeatDTO(id: e.id)).toList();
    params['seats'] = List<dynamic>.from(seatDTOS.map((e) => e));
    return params;
  }

  Reservation(
      {this.id,
      this.passenger,
      this.bookedRoute,
      this.reservationBookingDate,
      this.reservedSeats});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    print(json);
    var res = Reservation(
        id: json['id'],
        passenger: Passenger.fromJson(json['passenger']),
        bookedRoute: RouteModel.fromJson(json['bookedRoute']),
        reservationBookingDate: DateTime.parse(json['reservationBookingDate']),
        reservedSeats: List<SeatModel>.from((json['reservedSeats'])
            .map((i) => SeatModel.fromJson(i, true))
            .toList()));
    print('ret');
    return res;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'passenger': passenger,
        'bookedRoute': bookedRoute.toJson(),
        'reservationBookingDate': reservationBookingDate.toIso8601String(),
        'reservedSeats':
            reservedSeats.map((seat) => seat.toJson().toString()).toList()
      };

  String toString() {
    return this.toJson().toString();
  }
}
