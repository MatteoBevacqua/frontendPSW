import 'package:first_from_zero/Layout.dart';
import 'package:first_from_zero/SearchRoutes.dart';
import 'package:first_from_zero/models/RouteModel.dart';
import 'package:first_from_zero/support/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookRoute extends StatefulWidget {

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<BookRoute> {
  RouteModel selected;
  List<TrainSeat> seats;
  _BookingState() {
    selected = GlobalData.instance.currentlySelected;
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
      TrainSeat()
    ]));
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
        child: InkWell(child: Icon(Icons.event_seat_rounded)));
  }
}
