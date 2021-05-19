import 'dart:convert';

import 'package:flutter/material.dart';

class EventPeoplePage extends StatefulWidget {

  // ignore: non_constant_identifier_names
  var event_detail;
  // ignore: non_constant_identifier_names
  var event_people;

  // ignore: non_constant_identifier_names
  EventPeoplePage({this.event_detail, this.event_people});


  @override
  _EventPeoplePageState createState() => _EventPeoplePageState();
}

class _EventPeoplePageState extends State<EventPeoplePage> {
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
                      "รายชื่อผู้เข้าร่วมกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),                    
                  ],
                ),
              ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(widget.event_people.length, (index) {
                return Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.event_people[index]['first_name'] + " " + widget.event_people[index]['last_name'],
                        style: TextStyle(fontSize: 16),
                      ),
                    );
              }),
            ),
          )
            
        ],
      ))),
    );
  }
}
