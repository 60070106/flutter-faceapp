import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmitl64app/pages/approver/documentcheck_page.dart';
import 'package:kmitl64app/pages/camper/home_page.dart';
import 'package:kmitl64app/pages/login/signin_field_page.dart';
import 'package:kmitl64app/pages/organizer/home.dart';
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

    if (token != null) {
      var userJson = localStorage.getString('user');

      var user = json.decode(userJson);
      var data = {"username": user['username']};

      var resDataAttendance =
          await CallApi().postData(data, 'event_camp_attendance/');
      var bodyDataAttendance = json.decode(resDataAttendance.body);

      var resHomepage = await CallApi().getData('get_all_event/');
      var bodyHomepage = json.decode(resHomepage.body);
      eventData = bodyHomepage;
      userData = user;
      eventAttendance = bodyDataAttendance;

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
              ? userData['is_camper']
                  ? HomePage(
                      data: eventData,
                      userdata: userData,
                      eventAttendance: eventAttendance,
                    )
                  : userData['is_organizer']
                      ? OrganizerPage(
                          data: eventData,
                        )
                      : userData['is_approver']
                          ? DocumentCheckPage(
                              data: eventData,
                              user: userData,
                            )
                          : LogInPage()
              : LogInPage()),
    );
  }
}
