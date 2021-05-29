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
  int child, adult;

  TrainSeat(
      {this.seat,
      this.selected,
      this.selectedByMe = false,
      this.modifying = false,
      this.child = 0,
      this.adult = 0}) {
    this.selected = seat.isBooked;
  }

  _SeatState createState() => _SeatState(
      seatModel: seat,
      selected: seat.isBooked,
      selectedByMe: selectedByMe,
      modifying: modifying,
      adultIndex: adult,
      childIndex: child);
}

class _SeatState extends State<TrainSeat> {
  bool selected, selectedByMe, modifying;

  SeatModel seatModel;

  _SeatState(
      {this.seatModel,
      this.selected,
      this.selectedByMe,
      this.modifying,
      this.adultIndex,
      this.childIndex});

  Color color;
  final Icon icon = Icon(Icons.event_seat_sharp, color: Colors.black);
  TextStyle descr = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
  List<ButtonStyle> styles = [
    TextButton.styleFrom(backgroundColor: Colors.transparent),
    TextButton.styleFrom(backgroundColor: Colors.amberAccent)
  ];

  int childIndex, adultIndex;

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
          onPressed: (!selectedByMe)
              ? null
              : () {
                  setState(() {
                    if (!modifying)
                      GlobalData.selectedToBook.remove(seatModel);
                    else
                      GlobalData.currentBooking.remove(seatModel);
                    selectedByMe = false;
                    selected = false;
                    childIndex = adultIndex = seatModel.pricePaid = 0;
                  });
                  print(GlobalData.currentBooking);
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
                  style: styles[childIndex],
                  onPressed: (selected && !selectedByMe)
                      ? null
                      : () {
                          if (!selectedByMe) {
                            selectedByMe = true;
                            if (modifying) {
                              GlobalData.currentBooking.forceAdd(seatModel);
                            } else
                              GlobalData.selectedToBook.add(seatModel);
                          } else {
                            if (modifying) {
                              SeatModel copy = seatModel.deepCopy();
                              copy.pricePaid = seatModel.childrenPrice;
                              GlobalData.currentBooking.forceAdd(copy);
                            }
                          }
                          seatModel.pricePaid = seatModel.childrenPrice;
                          setState(() {
                            childIndex = 1;
                            adultIndex = 0;
                          });
                          print(GlobalData.currentBooking);
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
                  style: styles[adultIndex],
                  onPressed: (selected && !selectedByMe)
                      ? null
                      : () {
                          if (!selectedByMe) {
                            selectedByMe = true;
                            if (modifying) {
                              GlobalData.currentBooking.forceAdd(seatModel);
                            } else
                              GlobalData.selectedToBook.add(seatModel);
                          } else {
                            if (modifying) {
                              SeatModel copy = seatModel.deepCopy();
                              copy.pricePaid = seatModel.adultPrice;
                              GlobalData.currentBooking.forceAdd(copy);
                            }
                          }
                          seatModel.pricePaid = seatModel.adultPrice;
                          setState(() {
                            adultIndex = 1;
                            childIndex = 0;
                          });
                          print(GlobalData.currentBooking);
                        }),
              Text(seatModel.adultPrice.toString() + "€")
            ],
          )
        ])
      ]),
    ]);
  }
}
