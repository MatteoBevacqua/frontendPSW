import 'package:first_from_zero/CircularIconButton.dart';
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
    return Flexible(
        child: ListView.builder(
      itemCount: seats.length,
      itemBuilder: (context, index) {
        return TrainSeat(seat: seats[index]);
      },
    ));
  }
}

class TrainSeat extends StatefulWidget {
  final SeatModel seat;

  TrainSeat({this.seat});

  _SeatState createState() => _SeatState(seatModel: seat);
}

class _SeatState extends State<TrainSeat> {
  bool selected;
  final SeatModel seatModel;

  _SeatState({this.seatModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: CircularIconButton(
          onPressed: () => {print(seatModel.toJson().toString())},
          icon: Icons.event_seat_sharp,

        ));
  }
}
