import 'package:first_from_zero/support/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:first_from_zero/models/RouteModel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'InputField.dart';

class SearchRoutes extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchRoutes> {
  TextEditingController _leftSearchController = TextEditingController(),
      _rightSearchController = TextEditingController();
  DateTime _fromDate, _toDate;
  bool _searching = false;
  List<RouteModel> _routes;

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
          children: [top(), bottom()],
        ),
      ),
    );
  }

  Widget top() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(
                child: InputField(
                  labelText: "Departure City",
                  controller: _rightSearchController,
                  onSubmit: (value) {
                    _submitSearch();
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                  icon: Icon(CupertinoIcons.arrow_left_right_square_fill),
                  highlightColor: Colors.black,
                  onPressed: () {
                    var temp = _rightSearchController.text;
                    _rightSearchController.text = _leftSearchController.text;
                    _leftSearchController.text = temp;
                  },
                ),
              ),
              Flexible(
                child: InputField(
                  labelText: "Arrival City",
                  controller: _leftSearchController,
                  onSubmit: (value) {
                    _submitSearch();
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
                      _submitSearch();
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
                      onPressed: () => _selectDate(this.context, false),
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

  Widget bottom() {
    return !_searching
        ? _routes == null
            ? SizedBox.shrink()
            : _routes.length == 0
                ? Text("No match found")
                : showResults()
        : CircularProgressIndicator();
  }

  Widget showResults() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: _routes.length,
          itemBuilder: (context, index) {
            return RouteCard(
              route: _routes[index],
            );
          },
        ),
      ),
    );
  }

  /*void _search(){
    if(_leftSearchController.text == '' && _rightSearchController.text == '')
      return;
    if(_leftSearchController.text != '')
  }*/

  void _submitSearch() {
    setState(() {
      _searching = true;
      _routes = null;
    });
    print(_rightSearchController.text);
    print(_leftSearchController.text);
    Model.sharedInstance
        .searchRoutes(_rightSearchController.text, _leftSearchController.text,
            _fromDate, _toDate)
        .then((result) {
      setState(() {
        _searching = false;
        _routes = result;
      });
    });
  }
}

class RouteCard extends StatelessWidget {
  final RouteModel route;

  RouteCard({Key key, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        print("void");
      },
      hoverColor: Colors.black,
      highlightColor: Colors.black,
      child: new Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Row(children: [
                  Text(route.departureStation.toString(),
                      style: TextStyle(fontSize: 25))
                ]),
                Row(children: [
                  Text(DateFormat.yMMMMEEEEd()
                          .format(route.departureTime)
                          .toString() +
                      "  " +
                      DateFormat.Hms().format(route.departureTime).toString())
                ])
              ]),
              Column(children: [
                Row(children: [Icon(Icons.arrow_forward)]),
                Row(children: [Text(route.routeLength.toString() + " km")])
              ]),
              Column(children: [
                Row(children: [
                  Text(route.arrivalStation.toString(),
                      style: TextStyle(fontSize: 25))
                ]),
                Row(children: [
                  Text(DateFormat.yMMMMEEEEd()
                          .format(route.arrivalTime)
                          .toString() +
                      "  " +
                      DateFormat.Hms().format(route.arrivalTime).toString())
                ])
              ])
            ],
          ),
        ),
      ),
    );
  }
}
