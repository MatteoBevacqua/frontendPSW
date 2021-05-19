import 'package:first_from_zero/pages/SearchRoutes.dart';
import 'package:first_from_zero/models/RouteModel.dart';
import 'package:first_from_zero/models/SeatModel.dart';
import 'package:first_from_zero/support/Global.dart';
import 'package:first_from_zero/support/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    return Container(
        child: Column(children: [
      RouteCard(route: selected),
      seats == null ? CircularProgressIndicator() : getSeats2()
    ]));
  }

  Widget getSeats() {
    return Container(
        child: ListView.builder(
      itemCount: seats.length,
      itemBuilder: (context, index) {
        return TrainSeat(seat: seats[index]);
      },
    ));
  }

  Widget getSeats2() {
    return Flexible(
        child: GridView.builder(
      itemCount: seats.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          mainAxisExtent: 50),
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
  bool selected;
  SeatModel seatModel;
  Color color;
  final Icon icon = Icon(Icons.event_seat_sharp, color: Colors.black);

  _SeatState(SeatModel s) {
    seatModel = s;
    color = seatModel.isBooked ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        elevation: 3.0,
        fillColor: color,
        shape: CircleBorder(),
        onPressed: () {
          GlobalData.instance.selectedToBook.add(seatModel);
          print(GlobalData.instance.selectedToBook);
        },
        child: seatModel.direction == FacingDirection.OPPOSITE
            ? Transform.rotate(angle: 180 * math.pi / 180, child: icon)
            : icon);
  }
}
