import 'dart:async';

import 'package:frontendpsw/managers/RestManager.dart';
import 'package:frontendpsw/models/Reservation.dart';
import 'package:frontendpsw/myWidgets/TrainSeat.dart';
import 'package:frontendpsw/pages/SearchRoutes.dart';
import 'package:frontendpsw/models/SeatModel.dart';
import 'package:frontendpsw/support/Global.dart';
import 'package:frontendpsw/support/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Layout.dart';

class BookRoute extends StatefulWidget {
  final LayoutState parentState;

  BookRoute({this.parentState});

  @override
  _BookingState createState() => _BookingState(parentState: parentState);
}

class _BookingState extends State<BookRoute> implements Stalker  {
  List<SeatModel> seats;
  HTTPResponseWrapper wrapper = HTTPResponseWrapper();
  final LayoutState parentState;

  _BookingState({this.parentState}) {
    GlobalData.observer.addStalker(this);
  }



  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    if (GlobalData.currentlySelected != null) _updateSeatsAndRebuild();
    GlobalData.subtotal = 0;
    GlobalData.selectedToBook.clear();
  }

  void _updateSeatsAndRebuild() async {
     Model.sharedInstance
        .getAvailableSeatsOnRoute(GlobalData.currentlySelected)
        .then((result) {
      setState(() {
        seats = result;
        GlobalData.subtotal = 0;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _bookSeats() async {
    Text toShow;
    for (SeatModel s in GlobalData.selectedToBook) {
      (s.pricePaid);
      if (s.pricePaid == 0) {
        showDialog(
            context: this.context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Select a price for each seat first!"));
            });
        return;
      }
    }
    bool successful = false;
    if (!GlobalData.userIsLoggedIn || GlobalData.selectedToBook.length == 0) {
      if (!GlobalData.userIsLoggedIn)
        toShow = Text("You must be logged in in order to book seats");
      else
        toShow = Text("Select some seats first");
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(title: toShow);
          });
      return;
    }
    Reservation reservation = Reservation();
    reservation.bookedRoute = GlobalData.currentlySelected;
    reservation.reservedSeats = GlobalData.selectedToBook;
    await Model.sharedInstance.postReservation(reservation, wrapper);
    switch (wrapper.response) {
      case 406:
        {
          toShow = Text(
              "You already made a reservation for this route,\nif you want to add or remove seats\nedit the existing one from the user page");
        }
        break;
      case 409:
        {
          toShow = Text(
              "Looks like someone booked some of your seats before you...");
          Model.sharedInstance
              .getAvailableSeatsOnRoute(GlobalData.currentlySelected)
              .then((result) {
            setState(() {
              seats = result;
            });
          });
        }
        break;
      default:
        {
          Model.sharedInstance
              .getById(GlobalData.currentlySelected.id)
              .then((value) =>
          {
            setState(() {
              GlobalData.currentlySelected = value;
            })
          });
          successful = true;
          toShow = Text(
              "Reservation placed successfully!\nYou can edit or delete it from the user page on your right");
          parentState.goToBooking();
        }
        break;
    }
    _updateSeatsAndRebuild();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: toShow);
        });
    GlobalData.selectedToBook.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: top());
  }

  Widget top() {
    return GlobalData.currentlySelected == null
        ? Center(
        child: Text(
          "Select a route first",
          style: TextStyle(fontSize: 20),
        ))
        : ok();
  }

  Widget ok() {
    return Column(children: [
      RouteCard(route: GlobalData.currentlySelected),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        TextButton.icon(
            onPressed: () => _bookSeats(),
            icon: Icon(Icons.shopping_cart_outlined,
                color: Theme
                    .of(context)
                    .primaryColor),
            style: TextButton.styleFrom(padding: const EdgeInsets.all(16.0)),
            label: Text("Book the seats",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decorationThickness: 2,
                    color: Theme
                        .of(context)
                        .primaryColor))),
        Row(children: [
          Text("Subtotal : ",
              style: TextStyle(
                fontSize: 17,
              )),
          Text(GlobalData.subtotal.toString() + "€",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ))
        ])
      ]),
      SizedBox(height: 50),
      seats == null ? CircularProgressIndicator() : getSeats2(),
    ]);
  }

  Widget getSeats2() {
    seats.sort((a, b) => a.id.compareTo(b.id));
    return Expanded(
        flex: 1,
        child: GridView.builder(
          itemCount: seats.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (BuildContext context, int index) {
            return TrainSeat(seat: seats[index], modifying: false);
          },
        ));
  }

  @override
  void receiveUpdate() {
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
