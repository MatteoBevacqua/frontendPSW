import 'package:first_from_zero/managers/RestManager.dart';
import 'package:first_from_zero/models/Reservation.dart';
import 'package:first_from_zero/models/SeatModel.dart';
import 'package:first_from_zero/myWidgets/ReservationCard.dart';
import 'package:first_from_zero/myWidgets/TrainSeat.dart';
import 'package:first_from_zero/support/Global.dart';
import 'package:first_from_zero/support/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../myWidgets/CircularIconButton.dart';
import '../myWidgets/InputField.dart';
import '../models/Passenger.dart';
import 'SearchRoutes.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserPage>
    with AutomaticKeepAliveClientMixin<UserPage> {
  bool _adding = false;
  List<Reservation> _myRes;
  Passenger _justAddedUser;
  List<SeatModel> resSeats;

  TextEditingController _firstNameFiledController = TextEditingController();
  TextEditingController _lastNameFiledController = TextEditingController();
  TextEditingController _emailFiledController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    if (GlobalData.userIsLoggedIn)
      Model.sharedInstance.getReservations().then((value) =>
          setState(() {
            _myRes = value;
          }));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalData.userHasAnAccount
        ? (GlobalData.userIsLoggedIn ? loggedIn() : login())
        : register();
  }

  Widget modifyReservation(Reservation r) {
    GlobalData.clearBookingData();
    GlobalData.currentBooking = Set.from(r.reservedSeats);
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit reservation"),
        ),
        body: Column(children: [
          RouteCard(route: r.bookedRoute),
          SizedBox(height: 20),
          TextButton.icon(
              onPressed: () async {
                var exitCode = await Model.sharedInstance.modifyReservation(r);
                GlobalData.clearBookingData();
                Text toShow;
                _getMyReservations();
                if (exitCode)
                  toShow = Text("Modification successful!");
                else
                  toShow = Text(
                      "Some of the seats you wanted to add have already been booked!");
                showDialog(
                    context: this.context,
                    builder: (BuildContext context) {
                      return AlertDialog(title: toShow);
                    });
              },
              icon: Icon(Icons.edit, color: Theme
                  .of(context)
                  .primaryColor),
              style: TextButton.styleFrom(padding: const EdgeInsets.all(16.0)),
              label: Text("Submit changes",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decorationThickness: 2,
                      color: Theme
                          .of(context)
                          .primaryColor))),
          SizedBox(height: 50),
          Expanded(
              flex: 1,
              child: GridView.builder(
                itemCount: resSeats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  SeatModel reservedDTO;
                  bool byMe = r.reservedSeats.contains(resSeats[index]);
                  if (byMe) reservedDTO =
                      r.reservedSeats.firstWhere((element) => element.id ==
                          resSeats[index].id);

                  return TrainSeat(
                  seat: resSeats[index],
                  selectedByMe: byMe,
                  selected: resSeats[index].isBooked,
                  modifying: true ,
                  adult: resSeats[index].isBooked && byMe &&reservedDTO.pricePaid==resSeats[index].adultPrice?1:0 ,
                  child: resSeats[index].isBooked && byMe && reservedDTO.pricePaid==resSeats[index].childrenPrice?1:0 );
                },
              ))
        ]));
  }

  Widget showRes() {
    return Expanded(
      child: Container(
          child: ListView.builder(
            itemCount: _myRes.length,
            itemBuilder: (context, index) {
              return ReservationCard(
                reservation: _myRes[index],
                modify: () async {
                  resSeats = await Model.sharedInstance
                      .getAvailableSeatsOnRoute(_myRes[index].bookedRoute);
                  resSeats.sort((a, b) => a.id.compareTo(b.id));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              modifyReservation(_myRes[index])));
                },
                delete: () async {
                  bool value = await Model.sharedInstance.deleteReservation(
                      _myRes[index],
                      wrapper: HTTPResponseWrapper());
                  Text toShow;
                  if (value) {
                    Model.sharedInstance
                        .getById(GlobalData.currentlySelected.id)
                        .then((value) =>
                    {
                      setState(() {
                        GlobalData.currentlySelected = value;
                      })
                    });
                    toShow = Text("Reservation deleted successfully!");
                  } else
                    toShow = Text("There was an error,try again");
                  showDialog(
                      context: this.context,
                      builder: (BuildContext context) {
                        return AlertDialog(title: toShow);
                      });
                  _getMyReservations();
                },
                //  onTap: () => setSelectedInCard(_routes[index]),
              );
            },
          )),
    );
  }

  Widget loggedIn() {
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("My bookings",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                      onPressed: () {
                        Model.sharedInstance.logOut();
                        setState(() {
                          GlobalData.userIsLoggedIn = false;
                        });
                        print("bruh");
                      },
                      icon: Icon(Icons.logout, color: Colors.black),
                      label: Text("Logout",
                          style: TextStyle(color: Colors.black, fontSize: 19)))
                ])),
        _myRes == null ? CircularProgressIndicator() : showRes()
      ]),
    );
  }

  Widget login() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  InputField(
                    labelText: "Email",
                    controller: _emailFiledController,
                  ),
                  InputField(
                    labelText: "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularIconButton(
                              icon: Icons.arrow_forward,
                              onPressed: () {
                                _login();
                              },
                            ),
                            TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                            (states) =>
                                        Theme
                                            .of(context)
                                            .primaryColor)),
                                onPressed: () {
                                  setState(
                                        () {
                                      GlobalData.userHasAnAccount = false;
                                    },
                                  );
                                },
                                icon: Icon(Icons.arrow_back),
                                label: Text(
                                    "Don't have an account ?\n     register"))
                          ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget register() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  InputField(
                    labelText: "First Name",
                    controller: _firstNameFiledController,
                  ),
                  InputField(
                    labelText: "Last Name",
                    controller: _lastNameFiledController,
                  ),
                  InputField(
                    labelText: "Email",
                    controller: _emailFiledController,
                  ),
                  InputField(
                    labelText: "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                            (states) =>
                                        Theme
                                            .of(context)
                                            .primaryColor)),
                                onPressed: () {
                                  _register();
                                },
                                icon: Icon(Icons.app_registration),
                                label: Text("Register")),
                            TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                            (states) =>
                                        Theme
                                            .of(context)
                                            .primaryColor)),
                                onPressed: () =>
                                {
                                  setState(() {
                                    GlobalData.userHasAnAccount = true;
                                  })
                                },
                                label: Text(
                                    "Already have an account ? \n      Login"),
                                icon: Icon(Icons.login))
                          ])),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: _adding
                          ? CircularProgressIndicator()
                          : _justAddedUser != null
                          ? Text("Welcome!")
                          : SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getMyReservations() {
    Model.sharedInstance.getReservations().then((value) =>
        setState(() {
          _myRes = value;
          if (_myRes != null) _myRes.sort((a, b) => a.id.compareTo(b.id));
        }));
  }

  void _login() {
    if (!_checkFields(true)) return;
    print(_emailFiledController.text + " " + _passwordController.text);
    Model.sharedInstance
        .logIn(
        _emailFiledController.text.trim(), _passwordController.text.trim())
        .then((result) {
      setState(() {
        GlobalData.userIsLoggedIn = result == LogInResult.logged;
        if (GlobalData.userIsLoggedIn)
          _getMyReservations();
        else
          showDialog(
              context: this.context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                        "Login failed,check your credentials or register\nif you don't have an account yet!"));
              });
      });
    });
  }

  bool _checkFields(bool login) {
    if (login) {
      if (_passwordController.text == '' || _emailFiledController.text == '') {
        showDialog(
            context: this.context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Email and password are mandatory"));
            });
        return false;
      }
      return true;
    }
    if (_passwordController.text == '' ||
        _emailFiledController.text == '' ||
        _firstNameFiledController.text == '') {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("First name, email and password are mandatory"));
          });
      return false;
    }
    return true;
  }

  void _register() {
    if (!_checkFields(false)) return;
    setState(() {
      _adding = true;
      _justAddedUser = null;
    });
    _justAddedUser = Passenger(
      firstName: _firstNameFiledController.text.trim(),
      lastName: _lastNameFiledController.text.trim(),
      email: _emailFiledController.text.trim(),
      password: _passwordController.text.trim(),
    );
    Model.sharedInstance.addUser(_justAddedUser).then((result) {
      setState(() {
        _adding = false;
        if (result != null) GlobalData.userHasAnAccount = true;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}
