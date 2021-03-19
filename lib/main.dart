import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmitl64app/pages/home/home_page.dart';
import 'package:kmitl64app/pages/login/signin_field_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var eventData;
  var userData;
  var eventAttendance;

  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var token = localStorage.getString('token');
    var userJson = localStorage.getString('user');
    var event = localStorage.getString('data');
    var attendance = localStorage.getString('attendance');

    var user = json.decode(userJson);
    // ignore: non_constant_identifier_names
    var event_Data = json.decode(event);
    var attendanceData = json.decode(attendance);

    // print(user);
    // print(eventData.length);
    // print(attendanceData.length);

    if (token != null) {
      eventData = event_Data;
      userData = user;
      eventAttendance = attendanceData;

      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF9b9b9b),
      ),
      home: Scaffold(
        body: _isLoggedIn
            ? HomePage(
                data: eventData,
                userdata: userData,
                eventAttendance: eventAttendance,
              )
            : LogInPage(),
      ),
    );
  }
}
