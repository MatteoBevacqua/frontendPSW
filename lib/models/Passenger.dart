class Passenger {
  int id;
  String firstName;
  String lastName;
  String username;
  String email;
  String password;

  Passenger({this.id,this.firstName, this.lastName, this.username, this.email,this.password});

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      email: json['email'],
      password: json['password']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'username': username,
    'email': email,
    'password':password
  };

  @override
  String toString() {
    return firstName + " " + lastName;
  }


}