import 'package:first_from_zero/models/RouteModel.dart';
import 'package:first_from_zero/myWidgets/MyTypeAheadField.dart';
import 'package:first_from_zero/support/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'SearchRoutes.dart';

class ShortestRoute extends StatefulWidget {
  @override
  _ShortestRouteState createState() => _ShortestRouteState();
}

class _ShortestRouteState extends State<ShortestRoute> with AutomaticKeepAliveClientMixin<ShortestRoute>{
  TextEditingController _leftTypeAhead = TextEditingController(),
      _rightTypeAhead = TextEditingController();
  DateTime _selectedDay = DateTime.now();
  TextStyle style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TimeOfDay _time = TimeOfDay.now();
  List<RouteModel> _routeModels;

  @override
  Widget build(BuildContext context) {
    return Column(children: [top(),SizedBox( height: 25), bottom()]);
  }

  Widget bottom() {
    return _routeModels == null
        ? Text("No results matching the selected criteria")
        : Flexible(
            child: ListView.builder(
            itemCount: _routeModels.length,
            itemBuilder: (context, index) {
              return RouteCard(
                route: _routeModels[index],
                onTap: () => print(_routeModels[index]),
              );
            },
          ));
  }

  Widget top() {
    return Column(children: [
      SizedBox(height: 15),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Select a departure and an arrival city", style: style),
          SizedBox(height: 5),
          Text(
              "The system will find the fastest route on that day given the departure time",
              style: style)
        ],
      ),
      SizedBox(height: 15),
      Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
              child: MyTypeAheadField(
                  labelText: "Departure City",
                  onSuggestionSelected: (pattern) async {
                    return await Model.sharedInstance
                        .getSuggestedCitiesByPattern(pattern);
                  },
                  textEditingController: _leftTypeAhead,
                  onSubmit: (value) {
                    _submitSearch();
                    _leftTypeAhead.text = value.name;
                  }),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: IconButton(
                icon: Icon(CupertinoIcons.arrow_left_right_square_fill),
                highlightColor: Colors.black,
                onPressed: () {
                  var temp = _rightTypeAhead.text;
                  _rightTypeAhead.text = _leftTypeAhead.text;
                  _leftTypeAhead.text = temp;
                },
              ),
            ),
            Flexible(
              child: MyTypeAheadField(
                  labelText: "Arrival City",
                  onSuggestionSelected: (pattern) async {
                    return await Model.sharedInstance
                        .getSuggestedCitiesByPattern(pattern);
                  },
                  textEditingController: _rightTypeAhead,
                  onSubmit: (value) {
                    _rightTypeAhead.text = value.name;
                    _submitSearch();
                  }),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: OutlinedButton.icon(
                    onPressed: () => _selectDate(),
                    label: Text('Select a day'),
                    icon: Icon(Icons.today),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: Size(100, 50),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      elevation: 10,
                    )),
              ),
              Row(
                children: [
                  Text(
                    "Selected day : ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(DateFormat.yMMMMEEEEd().format(_selectedDay).toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          Column(children: [
            Padding(
                padding: EdgeInsets.all(15),
                child: OutlinedButton.icon(
                    onPressed: () => _pickTime(),
                    label: Text('Select a departure time'),
                    icon: Icon(Icons.timer),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: Size(100, 50),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      elevation: 10,
                    ))),
            Row(
              children: [
                Text("Selected departure time : ",
                    style: TextStyle(fontSize: 18)),
                Text(_time.format(this.context),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ],
            )
          ])
        ],
      ),
    ]);
  }

  void _submitSearch() {
    if (_leftTypeAhead.text.isNotEmpty && _rightTypeAhead.text.isNotEmpty)
      Model.sharedInstance
          .fastestRoute(_leftTypeAhead.text.trim(), _rightTypeAhead.text.trim(),
              _time, _selectedDay)
          .then((value) => setState(() {
                _routeModels = value;
              }));
  }

  void _pickTime() async {
    showTimePicker(context: this.context, initialTime: _time)
        .then((value) => setState(() {
              _time = value;
            }));
  }

  void _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: this.context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null)
      setState(() {
        _selectedDay = picked;
      });
  }

  @override

  bool get wantKeepAlive => true;


}
