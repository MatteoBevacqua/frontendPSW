import 'dart:async';

import 'package:first_from_zero/managers/RestManager.dart';
import 'package:first_from_zero/models/Reservation.dart';
import 'package:first_from_zero/myWidgets/TrainSeat.dart';
import 'package:first_from_zero/pages/SearchRoutes.dart';
import 'package:first_from_zero/models/SeatModel.dart';
import 'package:first_from_zero/support/Global.dart';
import 'package:first_from_zero/support/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookRoute extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<BookRoute> {
  List<SeatModel> seats;
  HTTPResponseWrapper wrapper = HTTPResponseWrapper();

  void _updateSeatsAndRebuild() async {
    await Model.sharedInstance
        .getAvailableSeatsOnRoute(GlobalData.currentlySelected)
        .then((result) {
      setState(() {
        seats = result;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _BookingState() {
    if (GlobalData.currentlySelected != null) _updateSeatsAndRebuild();
  }

  void _bookSeats() async {
    Text toShow;
    bool successful = false;
    print(GlobalData.selectedToBook);
    for (SeatModel s in GlobalData.selectedToBook) {
      print(s.pricePaid);
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
    if (!GlobalData.userIsLoggedIn || GlobalData.selectedToBook.length == 0) {
      if (!GlobalData.userIsLoggedIn)
        toShow = Text("You need to be logged in in order to book seats");
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
              .then((value) => {
                    setState(() {
                      GlobalData.currentlySelected = value;
                    })
                  });
          successful = true;
          toShow = Text(
              "Reservation placed successfully!\nYou can edit or delete it from the user page on your right");
        }
        break;
    }
    _updateSeatsAndRebuild();
    GlobalData.selectedToBook.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: toShow);
        });
    if (successful) {
      GlobalData.currentlySelected.seatsLeft -=
          GlobalData.selectedToBook.length;
      setState(() {});
    }
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
        : aight();
  }

  Widget aight() {
    return Column(children: [
      RouteCard(route: GlobalData.currentlySelected),
      SizedBox(height: 20),
      TextButton.icon(
          onPressed: () => _bookSeats(),
          icon: Icon(Icons.shopping_cart_outlined,
              color: Theme.of(context).primaryColor),
          style: TextButton.styleFrom(padding: const EdgeInsets.all(16.0)),
          label: Text("Book the seats",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  decorationThickness: 2,
                  color: Theme.of(context).primaryColor))),
      SizedBox(height: 50),
      seats == null ? CircularProgressIndicator() : getSeats2()
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
}
