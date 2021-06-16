import 'dart:async';
import 'dart:convert';
import 'package:frontendpsw/models/City.dart';
import 'package:frontendpsw/models/Passenger.dart';
import 'package:frontendpsw/models/Reservation.dart';
import 'package:frontendpsw/models/RouteModel.dart';
import 'package:frontendpsw/models/SeatModel.dart';
import 'package:frontendpsw/support/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Constants.dart';
import 'package:frontendpsw/managers/RestManager.dart';
import 'package:frontendpsw/models/AuthenticationData.dart';
import 'package:http/http.dart' as http;

enum LogInResult {
  logged,
  error_wrong_credentials,
  error_not_fully_setup,
  error_unknown,
}

class Model {
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();
  AuthenticationData _authenticationData;

  Future<LogInResult> logIn(String email, String password) async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = Constants.CLIENT_ID;
      params["username"] = email;
      params["password"] = password;
      String result = await _restManager.makePostRequest(
          Constants.ADDRESS_AUTHENTICATION_SERVER,
          Constants.REQUEST_LOGIN,
          params,
          type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      (_authenticationData);
      if (_authenticationData.hasError()) {
        if (_authenticationData.error == "Invalid user credentials") {
          return LogInResult.error_wrong_credentials;
        } else if (_authenticationData.error == "Account is not fully set up") {
          return LogInResult.error_not_fully_setup;
        } else {
          return LogInResult.error_unknown;
        }
      }
      _restManager.token = _authenticationData.accessToken;
      Timer.periodic(Duration(seconds: (_authenticationData.expiresIn - 50)),
          (Timer t) {
        _refreshToken();
      });
      return LogInResult.logged;
    } catch (e) {
      (e);
      return LogInResult.error_unknown;
    }
  }

  Future<RouteModel> getById(int routeId) async {
    Map<String, String> params = Map();
    params['routeId'] = routeId.toString();
    try {
      return RouteModel.fromJson(json.decode(await _restManager.makeGetRequest(
          Constants.SERVER_ADDRESS,
          Constants.ROUTES + Constants.ROUTE_BY_ID,
          params)));
    } catch (e) {
      (e);
      return null;
    }
  }

  Future<List<Reservation>> getReservations() async {
    try {
      var res = List<Reservation>.from(json
          .decode(await _restManager.makeGetRequest(Constants.SERVER_ADDRESS,
              Constants.RESERVATIONS + Constants.GET_RESERVATIONS))
          .map((i) => Reservation.fromJson(i))
          .toList());
      return res;
    } catch (e) {
      (e);
      return null;
    }
  }

  Future<int> getNumberOfSeatsLeft(int routeId) async {
    Map<String, String> params = Map();
    params['routeId'] = routeId.toString();
    var resp = json.decode(await _restManager.makeGetRequest(
        Constants.SERVER_ADDRESS, Constants.UPDATE_SEATS_BACKGROUND, params));
    return resp;
  }

  Future<bool> logOut() async {
    try {
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken;
      await _restManager.makePostRequest(
          Constants.ADDRESS_AUTHENTICATION_SERVER,
          Constants.REQUEST_LOGOUT,
          params,
          type: TypeHeader.urlencoded);
      return true;
    } catch (e) {
      return false;
    }
  }

/*
  Future<List<Product>> searchProduct(String name) async {
    Map<String, String> params = Map();
    params["name"] = name;
    try {
      return List<Product>.from(json
          .decode(await _restManager.makeGetRequest(
              Constants.ADDRESS_STORE_SERVER,
              Constants.REQUEST_SEARCH_PRODUCTS,
              params))
          .map((i) => Product.fromJson(i))
          .toList());
    } catch (e) {
      return null; // not the best solution
    }
  }
*/
  Future<List<City>> getSuggestedCitiesByPattern(String pattern) async {
    Map<String, String> params = Map();
    params['pattern'] = pattern;
    (pattern);
    try {
      var resp = await _restManager.makeGetRequest(
          Constants.SERVER_ADDRESS, Constants.CITY_AUTOFILL_ENDPOINT, params);
      return List<City>.from(
          json.decode(resp).map((i) => City.fromJson(i)).toList());
    } catch (e) {
      ("error  $e");
      return null; // not the best solution
    }
  }

  Future<List<RouteModel>> searchRoutes(String depCity, String arrCity,
      DateTime from, DateTime to, String seatsLeft) async {
    Map<String, String> params = Map();
    String endpoint;
    if (seatsLeft != '') {
      params['seatsLeft'] = seatsLeft;
    }
    if (from != null) params['startDate'] = from.toIso8601String();
    if (to != null) params['endDate'] = to.toIso8601String();
    if (depCity != '' && arrCity != '') {
      endpoint = Constants.ROUTE_BY_BOTH;
      params["departure"] = depCity;
      params["arrival"] = arrCity;
    } else if (depCity != '' || arrCity != '') {
      params["city"] = arrCity == '' ? depCity : arrCity;
      endpoint = arrCity == ''
          ? Constants.ROUTE_BY_DEPARTURE
          : Constants.ROUTE_BY_ARRIVAL;
    } else {
      endpoint = Constants.ALL_ROUTES;
    }
    (endpoint);
    try {
      return List<RouteModel>.from(json
          .decode(await _restManager.makeGetRequest(Constants.SERVER_ADDRESS,
              Constants.REQUEST_GET_ROUTES + endpoint, params))
          .map((i) => RouteModel.fromJson(i))
          .toList());
    } catch (e) {
      ("$e");
      return null; // not the best solution
    }
  }

  Future<List<SeatModel>> getAvailableSeatsOnRoute(RouteModel m) async {
    Map<String, String> params = Map();
    params['route_id'] = m.id.toString();
    try {
      return List<SeatModel>.from(json
          .decode(await _restManager.makeGetRequest(
              Constants.SERVER_ADDRESS, Constants.GET_SEATS, params))
          .map((i) => SeatModel.fromJson(i, false))
          .toList());
    } catch (e) {
      ("error + $e");
      return null; // not the best solution
    }
  }

  Future<Passenger> addUser(Passenger user) async {
    try {
      var rawResult = await _restManager.makePostRequest(
          Constants.SERVER_ADDRESS, Constants.REQUEST_ADD_PASSENGER, user);
      (rawResult);
      if (rawResult == null) {
        return null; // not the best solution
      } else {
        return Passenger.fromJson(jsonDecode(rawResult));
      }
    } catch (e) {
      return null; // not the best solution
    }
  }

  Future<bool> deleteReservation(Reservation r,
      {HTTPResponseWrapper wrapper}) async {
    Map<String, String> params = Map();
    params['id'] = r.id.toString();
    try {
      await (_restManager.makeDeleteRequest(
          Constants.SERVER_ADDRESS, Constants.DELETE_RESERVATION,
          value: params, wrapper: wrapper));
      return wrapper.response == 200;
    } catch (e) {
      (e.toString() + " in model");
      return false;
    }
  }

  Future<bool> modifyReservation(Reservation r) async {
    try {
      (GlobalData.currentBooking.toString() + " book");
      if (GlobalData.currentBooking.length == 0) {
        this.deleteReservation(r);
        return true;
      }
      Map<String, dynamic> body = Map();
      body['toModify'] = {'id': r.id};
      Set<SeatModel> toAdd = Set(), toRemove = Set(), toModify = Set();
      GlobalData.currentBooking.forEach((seat) {
        if (!r.reservedSeats.contains(seat)) {
          toAdd.add(seat);
        } else {
          if (r.reservedSeats
                  .firstWhere((element) => element.id == seat.id)
                  .pricePaid !=
              seat.pricePaid) {
            toModify.add(seat);
          }
        }
      });
      r.reservedSeats.removeAll(GlobalData.currentBooking);
      toRemove = r.reservedSeats;
      body['changePrice'] = List<dynamic>.from(
          toModify.map((e) => {'id': e.id, 'pricePaid': e.pricePaid}));
      body['toAdd'] = List<dynamic>.from(
          toAdd.map((e) => {'id': e.id, 'pricePaid': e.pricePaid}));
      body['toRemove'] = List<dynamic>.from(toRemove.map((e) => {'id': e.id}));
      HTTPResponseWrapper wrapper = HTTPResponseWrapper();
      ("ing modified res");
      (body);
      await _restManager.makePutRequest(
          Constants.SERVER_ADDRESS, Constants.RESERVATIONS,
          body: body, wrapper: wrapper);
      if (wrapper.response == 200 &&
          GlobalData.currentlySelected != null &&
          GlobalData.currentlySelected.id == r.bookedRoute.id) {
        r.bookedRoute.id = GlobalData.currentlySelected.seatsLeft =
            GlobalData.currentlySelected.seatsLeft +
                toRemove.length -
                toAdd.length;
      }
      return wrapper.response == 200;
    } catch (e) {
      (e);
      return false;
    }
  }

  Future<Reservation> postReservation(
      Reservation r, HTTPResponseWrapper wrapper) async {
    try {
      var res = json.decode(await _restManager.makePostRequest(
          Constants.SERVER_ADDRESS,
          Constants.MAKE_RESERVATION,
          r.toPostableDTO(),
          wrapper: wrapper));
      (r.toPostableDTO().toString());
      return res;
    } catch (e) {
      return null; // not the best solution
    }
  }

  Future<List<City>> getAll() async {
    try {
      return List<City>.from(json
          .decode(await _restManager.makeGetRequest(
              Constants.SERVER_ADDRESS, Constants.CITIES + "/all", null))
          .map((i) => City.fromJson(i))
          .toList());
    } catch (e) {
      return null; // not the best solution
    }
  }

  Future<bool> _refreshToken() async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken;
      String result = await _restManager.makePostRequest(
          Constants.ADDRESS_AUTHENTICATION_SERVER,
          Constants.REQUEST_LOGIN,
          params,
          type: TypeHeader.urlencoded);
      (result);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if (_authenticationData.hasError()) {
        return false;
      }
      _restManager.token = _authenticationData.accessToken;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<RouteModel>> fastestRoute(
      String from, String to, TimeOfDay timeOfDay, DateTime day) async {
    Map<String, String> params = Map();
    params['from'] = from;
    params['to'] = to;
    params['hour'] = timeOfDay.hour.toString();
    params['minutes'] = timeOfDay.minute.toString();
    params['date'] = day.toIso8601String();
    var resp = await _restManager.makeGetRequest(
        Constants.SERVER_ADDRESS, Constants.REQUEST_GET_FASTEST_ROUTE, params);
    if (resp != '')
      return List<RouteModel>.from(
          json.decode(resp).map((i) => RouteModel.fromJson(i)).toList());
    return null;
  }
}
