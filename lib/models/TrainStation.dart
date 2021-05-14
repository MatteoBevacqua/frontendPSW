import 'City.dart';

class TrainStation {
  int id;

  String name;

  City city;

  TrainStation({this.id, this.name, this.city});

  factory TrainStation.fromJson(Map<String, dynamic> json) {
    return TrainStation(
      id: json['id'],
      name: json['name'],
      city: City.fromJson(json['city']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'city': city.toJson(),
      };

  @override
  String toString() {
    return name;
  }
}
