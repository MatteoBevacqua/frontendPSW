class City{

  String name;

  String country;
  City({this.name, this.country});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'country': country,
  };

  @override
  String toString() {
    return name + " " + country;
  }
}