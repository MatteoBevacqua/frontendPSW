import 'package:enum_to_string/enum_to_string.dart';

enum SeatClass { BUSINESS, ECONOMY, FIRST }

enum FacingDirection { TRAVEL_DIRECTION, OPPOSITE }

class SeatModel {
  int id;

  int wagonNumber;

  SeatClass seatClass;

  int adultPrice;

  int childrenPrice;

  FacingDirection direction;

  int trainId;

  SeatModel(
      {this.id,
      this.wagonNumber,
      this.seatClass,
      this.adultPrice,
      this.childrenPrice,
      this.direction});

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'],
      wagonNumber: json['wagonNumber'],
      seatClass: EnumToString.fromString(SeatClass.values, json['seatClass']),
      adultPrice: json['adultPrice'],
      childrenPrice: json['adultPrice'],
      direction: EnumToString.fromString(FacingDirection.values, json['direction']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'wagonNumber': wagonNumber,
        'seatClass': seatClass,
        'adultPrice': adultPrice,
        'childrenPrice': childrenPrice,
        'direction': direction,
      };

  @override
  String toString() {
    return id.toString() +
        " " +
        wagonNumber.toString() +
        " " +
        seatClass.toString();
  }
}
