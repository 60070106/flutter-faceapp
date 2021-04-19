import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmitl64app/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event_people.dart';

class EventRegisterPage extends StatefulWidget {

  // ignore: non_constant_identifier_names
  var event_detail;

  // ignore: non_constant_identifier_names
  EventRegisterPage({this.event_detail});

  @override
  _EventRegisterPageState createState() => _EventRegisterPageState();
}

class _EventRegisterPageState extends State<EventRegisterPage> {
  bool _isLoading = false;
  bool _isviewLoading = false;

  @override
  Widget build(BuildContext context) {
    // print(widget.organizer_data);
    // print(widget.event_detail);
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Information"),
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Center(
              child: Image.memory(
                base64.decode(widget.event_detail['event_image']),
                height: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.115,
                // color: Colors.grey,
                child: Center(
                  child: Text(
                    widget.event_detail['event_name'],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                )),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                // color: Colors.grey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "วันที่จัดกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.event_detail['duration'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      "สถานที่จัดกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.event_detail['location'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      "รายละเอียดกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.event_detail['detail'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      "รายละเอียดผู้จัดกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.event_detail['organizer']['first_name'] +
                            " " +
                            widget.event_detail['organizer']['last_name'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.event_detail['organizer']['phone'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.event_detail['organizer']['email'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Row(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 5, right: 5),
                                  child: Text(
                                    'Register',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                color: Colors.red,
                                disabledColor: Colors.grey,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        var userJson =
                                            localStorage.getString('user');
                                        var user = json.decode(userJson);

                                        setState(() {
                                          _isLoading = true;
                                          print("click register...");
                                        });

                                        var data = {
                                          "event_name":
                                              widget.event_detail['event_name'],
                                          "username": user['username'],
                                        };

                                        print(data);

                                        var res = await CallApi()
                                            .postData(data, 'event_camp_register/');
                                        var body = jsonDecode(res.body);

                                        print(body);

                                        if (body['success']) {
                                          var campRes = await CallApi()
                                              .postData(
                                                  data, 'event_camp_people/');
                                          var campBody =
                                              jsonDecode(campRes.body);

                                          
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EventPeoplePage(
                                                      event_detail:
                                                          widget.event_detail,
                                                      event_people: campBody,
                                                    )
                                                // builder: (context) => TestMyApp(),
                                                ),
                                          );

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        } else {
                                          final snackbar = SnackBar(
                                              content: Text(
                                                  'You are already registered for this event.'));

                                          setState(() {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackbar);
                                            _isLoading = false;
                                          });
                                        }
                                      }),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 5, right: 5),
                                  child: Text(
                                    'View participants',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                color: Colors.red,
                                disabledColor: Colors.grey,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: _isviewLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isviewLoading = true;
                                        });

                                        var data = {
                                          "event_name":
                                              widget.event_detail['event_name'],
                                        };

                                        var res = await CallApi().postData(
                                            data, 'event_camp_people/');
                                        var body = jsonDecode(res.body);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EventPeoplePage(
                                                      event_detail:
                                                          widget.event_detail,
                                                      event_people: body)
                                              // builder: (context) => TestMyApp(),
                                              ),
                                        );

                                        setState(() {
                                          _isviewLoading = false;
                                        });
                                      }),
                          ),
                        ),
                      ],
                    ),
                    // Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                  ],
                )),
          ],
        ),
      )),
    );
  }
}
