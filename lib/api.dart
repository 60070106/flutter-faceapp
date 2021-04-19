import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class CallApi{
  // final String _url = 'http://10.110.197.3:8000/api/';
  final String _url = 'http://e230be3ed70e.ngrok.io/api/';
  // final String _url = 'https://postgrekmitl64.herokuapp.com/api/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    // var fullUrl = _url + apiUrl + await _getToken();
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: {
          "Content-type" : "application/json; charset=utf-8",
          }
    );
  }
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
  }

  _setHeaders() => {
    "Content-type" : "application/json; charset=utf-8",
    // "Accept" : "application/json",
    // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
    // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    // "Access-Control-Allow-Methods": "POST, GET, OPTIONS"
  };

  // _getToken() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   return '?token=$token';
  // }
}