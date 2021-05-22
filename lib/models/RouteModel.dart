import 'TrainStation.dart';

class RouteModel {
  int id;

  TrainStation departureStation;

  TrainStation arrivalStation;

  DateTime departureTime;

  DateTime arrivalTime;

  int routeLength;
  int seatsLeft;
  RouteModel(
      {this.id,
      this.departureStation,
      this.arrivalStation,
      this.departureTime,
      this.arrivalTime,
      this.routeLength,this.seatsLeft});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
        id: json['id'],
        departureStation: TrainStation.fromJson(json['departureStation']),
        arrivalStation: TrainStation.fromJson(json['arrivalStation']),
        departureTime: DateTime.parse(json['departureTime']),
        arrivalTime: DateTime.parse(json['arrivalTime']),
        routeLength: json['routeLength'],
        seatsLeft: json['seatsLeft']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'routeLength': routeLength
      };


}
