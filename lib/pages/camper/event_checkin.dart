import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event_checkin_identity.dart';


class EventCheckPage extends StatefulWidget {
  var state;
  // ignore: non_constant_identifier_names
  var organizer_data;
  // ignore: non_constant_identifier_names
  var event_detail;

  // ignore: non_constant_identifier_names
  EventCheckPage({this.state, this.organizer_data, this.event_detail});

  @override
  _EventCheckPageState createState() => _EventCheckPageState();
}

class _EventCheckPageState extends State<EventCheckPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลกิจกรรม"),
        backgroundColor: Color(0xFF876aa4),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
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
                  // height: MediaQuery.of(context).size.height * 0.115,
                  // color: Colors.grey,
                  child: Center(
                    child: Text(
                      widget.event_detail['event_name'],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          widget.organizer_data['first_name'] +
                              " " +
                              widget.organizer_data['last_name'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          widget.organizer_data['phone'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          widget.organizer_data['email'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                      widget.state == "available"
                          ? Row(
                              children: [
                                Center(
                                  child: Container(
                                    width: 130,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: FlatButton(
                                          child: Text(
                                            'Check In',
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          color: Colors.lightGreen,
                                          disabledColor: Colors.grey,
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                          onPressed: _isLoading
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });

                                                  SharedPreferences
                                                      localStorage =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var userJson = localStorage
                                                      .getString('user');
                                                  var user =
                                                      json.decode(userJson);

                                                  var data = {
                                                    "username":
                                                        user['username'],
                                                    "event_name":
                                                        widget.event_detail[
                                                            'event_name'],
                                                    "status": "Check in"
                                                  };

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CheckinIdentityPage(
                                                                data: data,
                                                                userdata:
                                                                    user)),
                                                  );

                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                }),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: FlatButton(
                                          child: Text(
                                            'Check Out',
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          color: Colors.red,
                                          disabledColor: Colors.grey,
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                          onPressed: _isLoading
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });

                                                  SharedPreferences
                                                      localStorage =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var userJson = localStorage
                                                      .getString('user');
                                                  var user =
                                                      json.decode(userJson);

                                                  var data = {
                                                    "username":
                                                        user['username'],
                                                    "event_name":
                                                        widget.event_detail[
                                                            'event_name'],
                                                    "status": "Check out"
                                                  };

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CheckinIdentityPage(
                                                                data: data,
                                                                userdata:
                                                                    user)),
                                                  );

                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                }),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container()
                      // Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
