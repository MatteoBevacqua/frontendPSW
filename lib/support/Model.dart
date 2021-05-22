import 'dart:async';
import 'dart:convert';
import 'package:first_from_zero/models/City.dart';
import 'package:first_from_zero/models/Passenger.dart';
import 'package:first_from_zero/models/Reservation.dart';
import 'package:first_from_zero/models/RouteModel.dart';
import 'package:first_from_zero/models/SeatModel.dart';
import 'Constants.dart';
import 'package:first_from_zero/managers/RestManager.dart';
import 'package:first_from_zero/models/AuthenticationData.dart';
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
      print(_authenticationData);
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
      print(e);
      return LogInResult.error_unknown;
    }
  }

  Future<List<Reservation>> getReservations() async {
    try {
      var res = List<Reservation>.from(json
          .decode(await _restManager.makeGetRequest(
          Constants.SERVER_ADDRESS, Constants.GET_RESERVATIONS, null))
          .map((i) => Reservation.fromJson(i))
          .toList());
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> getNumberOfSeatsLeft(int routeId) async {
    Map<String, String> params = Map();
    params['routeId'] = routeId.toString();
    var resp = json.decode(await _restManager.makeGetRequest(
        Constants.SERVER_ADDRESS, Constants.UPDATE_SEATS_BACKGROUND, params
    ));
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
    print(pattern);
    try {
      var resp = await _restManager.makeGetRequest(
          Constants.SERVER_ADDRESS, Constants.CITY_AUTOFILL_ENDPOINT, params);
      return List<City>.from(
          json.decode(resp).map((i) => City.fromJson(i)).toList());
    } catch (e) {
      print("error  $e");
      return null; // not the best solution
    }
  }

  Future<List<RouteModel>> searchRoutes(String depCity, String arrCity,
      DateTime from, DateTime to) async {
    Map<String, String> params = Map();
    String endpoint;
    if (from != null) params['startDate'] = from.toIso8601String();
    if (to != null) params['endDate'] = to.toIso8601String();
    if (depCity != '' && arrCity != '') {
      endpoint = Constants.ROUTE_BY_ALL;
      params["departure"] = depCity;
      params["arrival"] = arrCity;
    } else {
      params["city"] = arrCity == '' ? depCity : arrCity;
      endpoint = arrCity == ''
          ? Constants.ROUTE_BY_DEPARTURE
          : Constants.ROUTE_BY_ARRIVAL;
    }
    print(endpoint);
    try {
      return List<RouteModel>.from(json
          .decode(await _restManager.makeGetRequest(Constants.SERVER_ADDRESS,
          Constants.REQUEST_GET_ROUTES + endpoint, params))
          .map((i) => RouteModel.fromJson(i))
          .toList());
    } catch (e) {
      print("error + $e");
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
      print("error + $e");
      return null; // not the best solution
    }
  }

  Future<Passenger> addUser(Passenger user) async {
    try {
      var rawResult = await _restManager.makePostRequest(
          Constants.SERVER_ADDRESS, Constants.REQUEST_ADD_PASSENGER, user);
      print(rawResult);
      if (rawResult == null) {
        return null; // not the best solution
      } else {
        return Passenger.fromJson(jsonDecode(rawResult));
      }
    } catch (e) {
      return null; // not the best solution
    }
  }

  Future<Reservation> postReservation(Reservation r,
      HTTPResponseWrapper wrapper) async {
    try {
      var res = json.decode(await _restManager.makePostRequest(
          Constants.SERVER_ADDRESS,
          Constants.MAKE_RESERVATION,
          r.toPostableDTO(),
          wrapper: wrapper));
      print(wrapper.response);
      return res;
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
          Constants.SERVER_ADDRESS,
          Constants.DELETE_RESERVATION, params));
      return wrapper.response == 200;
    } catch (e) {
      print(e.toString() + " in model");
      return false;
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
      print(result);
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
}
