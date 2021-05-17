import 'package:first_from_zero/Layout.dart';
import 'package:first_from_zero/SearchRoutes.dart';
import 'package:first_from_zero/models/RouteModel.dart';
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
  RouteModel selected;
  List<SeatModel> seats;

  _BookingState() {
    selected = GlobalData.instance.currentlySelected;
    Model()
        .getAvailableSeatsOnRoute(selected)
        .then((result){
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
    return selected == null ? Text("Nothing to show") : aight();
  }

  Widget aight() {
    return Container(
        child: Column(children: [
      RouteCard(route: selected, onTap: () => print("tapped")),
      seats == null ? CircularProgressIndicator() : getSeats()
    ]));
  }

  Widget getSeats() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: seats.length,
          itemBuilder: (context, index) {
            return Text(seats[index].toString());
          },
        ),
      ),
    );
  }
  Widget getSeats2() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: seats.length,
          itemBuilder: (context, index) {
            return Text(seats[index].toString());
          },
        ),
      ),
    );
  }
}

class TrainSeat extends StatefulWidget {
  _SeatState createState() => _SeatState();
}

class _SeatState extends State<TrainSeat> {
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
            hoverColor: Colors.black12,
            highlightColor: Colors.black,
            child: Icon(Icons.event_seat_rounded)));
  }
}
