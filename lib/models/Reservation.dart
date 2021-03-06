import 'dart:convert';

import 'package:frontendpsw/models/RouteModel.dart';
import 'package:frontendpsw/models/SeatModel.dart';

import 'Passenger.dart';

class SeatDTO {
  SeatDTO({this.id,this.pricePaid});

  int id;
  int pricePaid;
  Map<String, dynamic> toJson() => {'id': id,'pricePaid':pricePaid};

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
  Set<SeatModel> reservedSeats;

  Map<String, dynamic> toPostableDTO() {
    Map<String, dynamic> params = Map();
    params['route'] ={'id':bookedRoute.id};
    List<SeatDTO> seatDTOS =
        reservedSeats.map((e) => SeatDTO(id: e.id,pricePaid: e.pricePaid)).toList();
    params['seats'] = List<dynamic>.from(seatDTOS);
    return params;
  }

  Reservation(
      {this.id,
      this.passenger,
      this.bookedRoute,
      this.reservationBookingDate,
      this.reservedSeats});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    var res = Reservation(
        id: json['id'],
        passenger: Passenger.fromJson(json['passenger']),
        bookedRoute: RouteModel.fromJson(json['bookedRoute']),
        reservationBookingDate: DateTime.parse(json['reservationBookingDate']),
        reservedSeats: Set<SeatModel>.from((json['reservedSeats'])
            .map((i) => SeatModel.fromJson(i, true))
            .toList()));
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
