import 'dart:io';
import 'dart:convert';
import 'package:first_from_zero/support/Constants.dart';
import 'package:http/http.dart';

enum TypeHeader { json, urlencoded }

class HTTPResponseWrapper {
  HTTPResponseWrapper({this.response});

  int response;
}

class RestManager {
  String token;

  Future<String> _makeRequest(
      String serverAddress, String servicePath, String method, TypeHeader type,
      {Map<String, String> value,
      dynamic body,
      HTTPResponseWrapper wrapper}) async {

    //TODO HTTPS
    Uri uri = Uri.http(serverAddress, servicePath, value);
    bool errorOccurred = false;
    try {
      var response;
      // setting content type
      String contentType;
      dynamic formattedBody;
      if (type == TypeHeader.json) {
        contentType = "application/json;charset=utf-8";
        formattedBody = json.encode(body);
      } else if (type == TypeHeader.urlencoded) {
        contentType = "application/x-www-form-urlencoded";
        formattedBody = body.keys.map((key) => "$key=${body[key]}").join("&");
      }
      print(formattedBody);
      // setting headers
      Map<String, String> headers = Map();
      headers[HttpHeaders.contentTypeHeader] = contentType;
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = 'bearer $token';
      }
      switch (method) {
        case "post":
          response = await post(
            uri,
            headers: headers,
            body: formattedBody,
          );
          break;
        case "get":
          response = await get(
            uri,
            headers: headers,
          );
          break;
        case "put":
          response = await put(
            uri,
            headers: headers,
            body: formattedBody
          );
          break;
        case "delete":
          response = await delete(uri, headers: headers);
          break;
      }
      if (wrapper != null) wrapper.response = response.statusCode;
      return response.body;
    } catch (err) {
      print(err + "in rest");
      if (wrapper != null) wrapper.response = -1;
      errorOccurred = true;
    }
  }

  Future<String> makePostRequest(
      String serverAddress, String servicePath, dynamic value,
      {TypeHeader type = TypeHeader.json, HTTPResponseWrapper wrapper}) async {
    return _makeRequest(serverAddress, servicePath, "post", type,
        body: value, wrapper: wrapper);
  }

  Future<String> makeGetRequest(String serverAddress, String servicePath,
      [Map<String, String> value, TypeHeader type]) async {
    return _makeRequest(serverAddress, servicePath, "get", type, value: value);
  }

  Future<String> makePutRequest(String serverAddress, String servicePath,
  { Map<String, String> value,dynamic body, TypeHeader type,HTTPResponseWrapper wrapper}) async {
    return _makeRequest(serverAddress, servicePath, "put", TypeHeader.json, body: body, value: value,wrapper: wrapper);
  }

  Future<String> makeDeleteRequest(String serverAddress, String servicePath,{HTTPResponseWrapper wrapper,
  Map<String, String> value, TypeHeader type}) async {
    return _makeRequest(serverAddress, servicePath, "delete", TypeHeader.json,
        value: value,wrapper: wrapper);
  }
}
