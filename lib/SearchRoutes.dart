import 'package:first_from_zero/CircularIconButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'InputField.dart';

class SearchRoutes extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchRoutes> {
  TextEditingController _leftSearchController = TextEditingController(),
      _rightSearchController = TextEditingController();
  String _from, _to;
  DateTime _fromDate, _toDate;

  void _selectDate(BuildContext buildContext, bool first) async {
    final DateTime picked = await showDatePicker(
        context: buildContext,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null)
      setState(() {
        if (first)
          _fromDate = picked;
        else
          _toDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [top()],
        ),
      ),
    );
  }

  Widget top() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              Flexible(
                child: InputField(
                  labelText: "Search Routes",
                  controller: _leftSearchController,
                  onSubmit: (value) {
                    print(value);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                  icon: Icon(CupertinoIcons.arrow_left_right_square_fill),
                  highlightColor: Colors.black,
                  onPressed: () {
                    print("bruh3");
                  },
                ),
              ),
              Flexible(
                child: InputField(
                  labelText: "Search Routes",
                  controller: _rightSearchController,
                  onSubmit: (value) {
                    print(value);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(1),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: IconButton(
                    icon: Icon(Icons.search_rounded),
                    highlightColor: Colors.black,
                    onPressed: () {
                      print("bruh2");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: OutlinedButton.icon(
                      onPressed: () => _selectDate(this.context, true),
                      label: Text('Press here to select a starting date'),
                      icon: Icon(Icons.date_range),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: Size(100, 50),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        elevation: 10,

                      )),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: OutlinedButton.icon(
                      onPressed: () => _selectDate(this.context, true),
                      label: Text('Press here to select an ending date'),
                      icon: Icon(Icons.date_range),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: Size(100, 50),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        elevation: 10,
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
