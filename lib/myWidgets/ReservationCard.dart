import 'package:first_from_zero/models/Reservation.dart';
import 'package:first_from_zero/support/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final TextStyle style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
  Function delete,modify;
  ReservationCard({this.reservation,this.delete,this.modify});

  @override
  Widget build(BuildContext context) {
    return  Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(0),
        child: Row(children: [

          Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 14,
            child: Container(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Booking #" + reservation.id.toString(),
                      style: style),
                  Row(
                    children: <Widget>[
                      Text(
                        'Departure Station : ' ,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                         reservation.bookedRoute.departureStation.name,
                        style: style,
                      ),
                      SizedBox(width: 100),
                      Text(
                        'Arrival Station : ' ,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                            reservation.bookedRoute.arrivalStation.name,
                        style: style,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Departure Time : ',
                        style: style,
                      ),
                      Text(
                        Utils.formatDate(reservation.bookedRoute.departureTime),
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Arrival Time : ',
                        style: style,
                      ),
                      Text(
                        Utils.formatDate(reservation.bookedRoute.arrivalTime),
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                            onPressed: delete,
                            child: Text("Delete Booking")),
                        SizedBox(width: 20),
                        TextButton(
                            onPressed: null, child: Text("Modify Booking")),
                        SizedBox(width: 5)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
