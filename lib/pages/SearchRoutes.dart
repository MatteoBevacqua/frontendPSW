import 'package:first_from_zero/support/Global.dart';
import 'package:first_from_zero/support/Model.dart';
import 'package:first_from_zero/myWidgets/MyTypeAheadField.dart';
import 'package:first_from_zero/support/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:first_from_zero/models/RouteModel.dart';
import 'package:intl/intl.dart';
import 'Layout.dart';

typedef int RouteSorter(RouteModel a, RouteModel b);

class SearchRoutes extends StatefulWidget {
  final LayoutState parentState;

  SearchRoutes({this.parentState});

  _SearchState createState() => _SearchState(parent: parentState);
}

class _SearchState extends State<SearchRoutes>
    with AutomaticKeepAliveClientMixin<SearchRoutes> {
  final LayoutState parent;
  bool ascending = true;
  RouteSorter sort = (a,b)=>a.id.compareTo(b.id);
  final List<String> dropValues = [
    'Id',
    'Departure Station',
    'Arrival Station',
    'Departure Time',
    'Arrival Time',
    'Seats Left'
  ];
  String selected = 'Id';

  _SearchState({this.parent});

  DateTime _fromDate = DateTime.now(),
      _toDate = DateTime.now().add(Duration(days: 365));
  RouteModel _selected;
  bool _searching = false;
  List<RouteModel> _routes;
  TextEditingController _leftTypeAhead = TextEditingController(),
      _rightTypeAhead = TextEditingController();

  void setSelected(RouteModel model) {
    this._selected = model;
    print("selected is " + _selected.toJson().toString());
  }

  void _selectDate(BuildContext buildContext, bool first) async {
    final DateTime picked = await showDatePicker(
        context: buildContext,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    print(picked.toIso8601String());
    if (picked != null)
      setState(() {
        if (first)
          _fromDate = picked;
        else
          _toDate = picked;
      });
    _submitSearch();
    print(_fromDate.toString() + " " + _toDate.toString() + " ??? ");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [top(), bottom()],
          ),
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
                child: MyTypeAheadField(
                    labelText: "Departure City",
                    onSuggestionSelected: (pattern) async {
                      return await Model.sharedInstance
                          .getSuggestedCitiesByPattern(pattern);
                    },
                    textEditingController: _leftTypeAhead,
                    onSubmit: (value) {
                      print(value);
                      _leftTypeAhead.text = value.name;
                      _submitSearch();
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
                    _submitSearch();
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
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Row(children: [
                  Text("Ascending",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Checkbox(
                      value: ascending,
                      onChanged: (value) {
                        setState(() {
                          ascending = !ascending;
                          _routes.sort(sort);
                        });
                      })
                ]),
                Column(children: [
                  Text("Sort by",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                      onChanged: (value) {
                        if (_routes != null)
                          switch (value) {
                            case 'Id':
                              sort = (a, b) => ascending
                                  ? a.id.compareTo(b.id)
                                  : -a.id.compareTo(b.id);
                              break;
                            case 'Departure Station':
                              sort = (a, b) => ascending
                                  ? a.departureStation.id
                                      .compareTo(b.departureStation.id)
                                  : -b.departureStation.id
                                      .compareTo(a.departureStation.id);
                              break;
                            case 'Arrival Station':
                              sort = (a, b) => ascending ? a.arrivalStation.id
                                  .compareTo(b.arrivalStation.id) : b.arrivalStation.id
                                  .compareTo(a.arrivalStation.id);
                              break;
                            case 'Departure Time':
                              sort = (a, b) => ascending ?
                              a.departureTime.compareTo(b.departureTime):b.departureTime.compareTo(a.departureTime);
                              break;
                            case 'Arrival Time':
                            sort = (a, b) => ascending ?
                                  a.arrivalTime.compareTo(b.arrivalTime):b.arrivalTime.compareTo(a.arrivalTime);
                              break;
                            case 'Seats Left':
                              sort = (a, b) => ascending ?
                              a.seatsLeft.compareTo(b.seatsLeft):b.seatsLeft.compareTo(a.seatsLeft);
                              break;
                          }
                        _routes.sort(sort);
                        setState(() {
                          selected = value;
                        });
                      },
                      value: selected,
                      items: dropValues
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList())
                ])
              ]),
              Flexible(
                child: Column(
                  children: [
                    Text(
                        "From : " +
                            DateFormat.yMMMMEEEEd()
                                .format(_fromDate)
                                .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: OutlinedButton.icon(
                          onPressed: () => _selectDate(this.context, true),
                          label: Text('Modify the starting date'),
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
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(
                        "To : " +
                            DateFormat.yMMMMEEEEd().format(_toDate).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: OutlinedButton.icon(
                          onPressed: () => _selectDate(this.context, false),
                          label: Text('Modify the ending date'),
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
                    )
                  ],
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

  void setSelectedInCard(RouteModel route) {
    this.setSelected(route);
    GlobalData.currentlySelected = route;
    GlobalData.selectedToBook = List.empty(growable: true);
    this.parent.goToBooking();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget showResults() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: _routes.length,
          itemBuilder: (context, index) {
            return RouteCard(
              route: _routes[index],
              caller: this,
              onTap: () => setSelectedInCard(_routes[index]),
            );
          },
        ),
      ),
    );
  }

  void _submitSearch() {
    setState(() {
      _searching = true;
      _routes = null;
    });
    Model.sharedInstance
        .searchRoutes(
            _leftTypeAhead.text, _rightTypeAhead.text, _fromDate, _toDate)
        .then((result) {
      setState(() {
        _searching = false;
        _routes = result;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class RouteCard extends StatelessWidget {
  final RouteModel route;
  final _SearchState caller;
  final Function onTap;

  RouteCard({Key key, this.route, this.caller, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 25,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: new InkWell(
        hoverColor: Colors.white24,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Row(children: [
                  Text(route.departureStation.toString(),
                      style: TextStyle(fontSize: 25))
                ]),
                Row(children: [Text(Utils.formatDate(route.departureTime))])
              ]),
              Column(children: [
                Row(children: [Text("Route #" + route.id.toString())]),
                Row(children: [Icon(Icons.arrow_forward)]),
                Row(children: [Text(route.routeLength.toString() + " km")]),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(children: [
                      Text("Seats left: " + route.seatsLeft.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18))
                    ]))
              ]),
              Column(children: [
                Row(children: [
                  Text(route.arrivalStation.toString(),
                      style: TextStyle(fontSize: 25))
                ]),
                Row(children: [Text(Utils.formatDate(route.arrivalTime))])
              ])
            ],
          ),
        ),
      ),
    );
  }
}
