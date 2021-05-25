import 'dart:async';

import 'package:first_from_zero/managers/RestManager.dart';
import 'package:first_from_zero/models/Reservation.dart';
import 'package:first_from_zero/pages/SearchRoutes.dart';
import 'package:first_from_zero/models/SeatModel.dart';
import 'package:first_from_zero/support/Global.dart';
import 'package:first_from_zero/support/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:first_from_zero/support/Utils.dart';

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
    if (!GlobalData.userIsLoggedIn || GlobalData.selectedToBook.length <= 0) {
      print(GlobalData.userIsLoggedIn);
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
              "You already made a reservation for this route,\nif you want to add or remove seats\n edit the existing one from the user page");
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
          successful = true;
          toShow = Text(
              "Reservation placed successfully!\nYou can edit or delete it from the user page on your right");
        }
        break;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: toShow);
        });
    if (successful) {
      for (SeatModel s in GlobalData.selectedToBook) {
        s.isBooked = true;
      }
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

class TrainSeat extends StatefulWidget {
  @override
  bool operator ==(Object other) => other is TrainSeat && other.seat == seat;

  final SeatModel seat;
  bool selected = false, selectedByMe = false, modifying = false;

  TrainSeat({this.seat, this.selected, this.selectedByMe, this.modifying}) {
    this.selected = seat.isBooked;
    if (selectedByMe == null) selectedByMe = false;
    if (modifying == null) modifying = false;
  }

  _SeatState createState() => _SeatState(
      seatModel: seat,
      selected: seat.isBooked,
      selectedByMe: selectedByMe,
      modifying: modifying);
}

class _SeatState extends State<TrainSeat> {
  bool selected = false, selectedByMe = false, modifying = false;
  SeatModel seatModel;

  _SeatState(
      {this.seatModel, this.selected, this.selectedByMe, this.modifying});

  Color color;
  final Icon icon = Icon(Icons.event_seat_sharp, color: Colors.black);
  TextStyle descr = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    if (selected && !selectedByMe) {
      color = Colors.amber;
    } else {
      color = selectedByMe ? Colors.white : Colors.green;
    }
    return Column(children: [
      RawMaterialButton(
          constraints: BoxConstraints.expand(width: 50, height: 50),
          fillColor: color,
          shape: CircleBorder(),
          onPressed: (selected && !selectedByMe)
              ? null
              : () {
                  print(GlobalData.selectedToBook);
                  setState(() {
                    GlobalData.selectedToBook.add(seatModel);
                    setState(() {
                      if (!selectedByMe) {
                        selectedByMe = true;
                        selected = true;
                        if (modifying) GlobalData.toAdd.add(seatModel);
                      } else {
                        selectedByMe = false;
                        selected = false;
                        GlobalData.selectedToBook.remove(seatModel);
                        if (modifying) GlobalData.toRemove.add(seatModel);
                      }
                    });
                  });
                },
          child: seatModel.direction == FacingDirection.OPPOSITE
              ? Transform.rotate(angle: 180 * math.pi / 180, child: icon)
              : icon),
      SizedBox(height: 5),
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Seat Class: "),
          Text(
              seatModel.seatClass
                  .toString()
                  .substring(10)
                  .toLowerCase()
                  .capitalize(),
              style: descr)
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              TextButton(
                  child: Text("Children"),
                  onPressed: () {
                    print("pressed");
                  }),
              Text(seatModel.childrenPrice.toString() + "\€")
            ],
          ),
          Column(
            children: [
              TextButton(
                  child: Text("Adult"),
                  onPressed: () {
                    print("pressed2");
                  }),
              Text(seatModel.adultPrice.toString() + "\€")
            ],
          )
        ])
      ]),
    ]);
  }
}
