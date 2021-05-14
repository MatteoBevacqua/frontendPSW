import 'dart:async';
import 'dart:convert';
import 'package:first_from_zero/models/RouteModel.dart';
import 'Constants.dart';
import 'package:first_from_zero/managers/RestManager.dart';
import 'package:first_from_zero/models/AuthenticationData.dart';

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
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;
      String result = await _restManager.makePostRequest(
          Constants.ADDRESS_AUTHENTICATION_SERVER,
          Constants.REQUEST_LOGIN,
          params,
          type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
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
      return LogInResult.error_unknown;
    }
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
  Future<List<RouteModel>> searchRoutes(
      String depCity, String arrCity, DateTime from, DateTime to) async {
    Map<String, String> params = Map();
    String endpoint;
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
    try {
      return List<RouteModel>.from(json
          .decode(await _restManager.makeGetRequest(
              Constants.SERVER_ADDRESS,
              Constants.REQUEST_GET_ROUTES + endpoint,
              params))
          .map((i) => RouteModel.fromJson(i))
          .toList());
    } catch (e) {
      print("error + $e");
      return null; // not the best solution
    }
  }



/*  Future<User> addUser(User user) async {
    try {
      String rawResult = await _restManager.makePostRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_USER, user);
      if (rawResult
          .contains(Constants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS)) {
        return null; // not the best solution
      } else {
        return User.fromJson(jsonDecode(rawResult));
      }
    } catch (e) {
      return null; // not the best solution
    }
  }

  Future<List<City>> getAll() async {
    try {
      return List<City>.from(json
          .decode(await _restManager.makeGetRequest(
              Constants.ADDRESS_STORE_SERVER, Constants.CITIES + "/all",null))
          .map((i) => City.fromJson(i))
          .toList());
    } catch (e) {
      return null; // not the best solution
    }
  }
  */

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
