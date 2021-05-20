import 'package:first_from_zero/models/Reservation.dart';
import 'package:first_from_zero/pages/SearchRoutes.dart';
import 'package:first_from_zero/models/RouteModel.dart';
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
  RouteModel selected;
  List<SeatModel> seats, _selectedSeats;

  _BookingState() {
    selected = GlobalData.instance.currentlySelected;
    if (selected != null)
      Model().getAvailableSeatsOnRoute(selected).then((result) {
        setState(() {
          seats = result;
        });
      });
  }

  bool _bookSeats() {
    /*  if(!GlobalData.instance.userIsLoggedIn) showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("You need to be logged in in order to book seats"));
        });*/
    Reservation reservation = Reservation();
    reservation.bookedRoute = GlobalData.instance.currentlySelected;
    reservation.reservedSeats = GlobalData.instance.selectedToBook;
    print(reservation.bookedRoute.toString() + " S ");
    print(reservation.reservedSeats.length);
    print(reservation.toPostableDTO());
    Model.sharedInstance
        .postReservation(reservation)
        .then((value) => {print(value)});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: top());
  }

  Widget top() {
    return selected == null
        ? Center(
            child: Text(
            "Select a route first",
            style: TextStyle(fontSize: 20),
          ))
        : aight();
  }

  Widget aight() {
    return Column(children: [
      RouteCard(route: selected),
      SizedBox(height: 20),
      TextButton.icon(
          onPressed: () => _bookSeats(),
          icon: Icon(Icons.shopping_cart_outlined,color: Theme.of(context).primaryColor),
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
            return TrainSeat(seat: seats[index]);
          },
        ));
  }
}

class TrainSeat extends StatefulWidget {
  final SeatModel seat;

  TrainSeat({this.seat});

  _SeatState createState() => _SeatState(seat);
}

class _SeatState extends State<TrainSeat> {
  bool selected, selectedByMe = false;
  SeatModel seatModel;
  Color color;
  final Icon icon = Icon(Icons.event_seat_sharp, color: Colors.black);
  TextStyle descr = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

  _SeatState(SeatModel s) {
    seatModel = s;
  }

  @override
  Widget build(BuildContext context) {
    if (seatModel.isBooked) {
      color = Colors.red;
    } else {
      color = selectedByMe ? Colors.white : Colors.green;
    }
    return Column(children: [
      RawMaterialButton(
          constraints: BoxConstraints.expand(width: 50, height: 50),
          fillColor: color,
          shape: CircleBorder(),
          onPressed: seatModel.isBooked
              ? null
              : () {
                  GlobalData.instance.selectedToBook.add(seatModel);
                  print(GlobalData.instance.selectedToBook);
                  setState(() {
                    if (!selectedByMe)
                      selectedByMe = true;
                    else {
                      selectedByMe = false;
                      GlobalData.instance.selectedToBook.remove(seatModel);
                    }
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
