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
  bool isBooked;

  SeatModel(
      {this.id,
      this.wagonNumber,
      this.seatClass,
      this.adultPrice,
      this.childrenPrice,
      this.direction,
      this.isBooked});


  @override
  bool operator ==(Object other) => other is SeatModel && other.id == id ;


  factory SeatModel.fromJson(Map<String, dynamic> json,bool DTO) {
    if(DTO) json = json['seat'];
    return SeatModel(
        id: json['id'],
        wagonNumber: json['wagonNumber'],
        seatClass: EnumToString.fromString(SeatClass.values, json['seatClass']),
        adultPrice: json['adultPrice'],
        childrenPrice: json['childrenPrice'],
        direction:
            EnumToString.fromString(FacingDirection.values, json['direction']),
        isBooked: json['isBooked'] == null
            ? null
            : json['isBooked'].toString().toLowerCase() == 'true');

  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'wagonNumber': wagonNumber,
        'seatClass': seatClass,
        'adultPrice': adultPrice,
        'childrenPrice': childrenPrice,
        'direction': direction,
        'isBooked': isBooked
      };

  @override
  String toString() {
    return this.toJson().toString();
  }
}
