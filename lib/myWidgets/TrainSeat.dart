import 'package:first_from_zero/models/SeatModel.dart';
import 'package:first_from_zero/support/Global.dart';
import 'package:first_from_zero/support/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
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
  List<ButtonStyle> styles = [
    TextButton.styleFrom(backgroundColor: Colors.transparent),
    TextButton.styleFrom(backgroundColor: Colors.amberAccent)
  ];
  ButtonStyle styleChild =
          TextButton.styleFrom(backgroundColor: Colors.transparent),
      styleAdult = TextButton.styleFrom(backgroundColor: Colors.transparent);
  int childIndex = 0, adultIndex = 0;

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
                  setState(() {
                    print(GlobalData.selectedToBook);
                    if (!selectedByMe) {
                      selectedByMe = true;
                      selected = true;
                      if (modifying)
                        GlobalData.toAdd.add(seatModel);
                      else
                        GlobalData.selectedToBook.add(seatModel);
                    } else {
                      selectedByMe = false;
                      selected = false;
                      if (modifying)
                        GlobalData.toRemove.add(seatModel);
                      else
                        GlobalData.selectedToBook.remove(seatModel);
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
                  child: Text("Children",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  style: styleChild,
                  onPressed: (selected && !selectedByMe)
                      ? null
                      : () {
                          if (!selectedByMe) selectedByMe = !selectedByMe;
                          seatModel.pricePaid = seatModel.childrenPrice;
                          if (modifying) GlobalData.priceChanged.add(seatModel);
                          setState(() {
                            styleChild = styles[(childIndex + 1) % 2];
                            styleAdult = styles[0];
                          });
                        }),
              Text(seatModel.childrenPrice.toString() + "€")
            ],
          ),
          Column(
            children: [
              TextButton(
                  child: Text("Adult",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  style: styleAdult,
                  onPressed: (selected && !selectedByMe)
                      ? null
                      : () {
                          if (!selectedByMe) selectedByMe = !selectedByMe;
                          seatModel.pricePaid = seatModel.adultPrice;
                          if (modifying) GlobalData.priceChanged.add(seatModel);
                          setState(() {
                            styleAdult = styles[(childIndex + 1) % 2];
                            styleChild = styles[0];
                          });
                        }),
              Text(seatModel.adultPrice.toString() + "€")
            ],
          )
        ])
      ]),
    ]);
  }
}
