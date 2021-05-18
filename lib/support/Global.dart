import 'package:first_from_zero/models/RouteModel.dart';
import 'package:flutter/cupertino.dart';

class GlobalData {
  static final GlobalData instance = GlobalData();
  RouteModel currentlySelected;
  bool userHasAnAccount = false;
}
