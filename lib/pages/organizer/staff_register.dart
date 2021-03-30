import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrganizerEventDetailPage extends StatefulWidget {
  var data;
  OrganizerEventDetailPage({this.data});

  @override
  _OrganizerEventDetailPageState createState() =>
      _OrganizerEventDetailPageState();
}

class _OrganizerEventDetailPageState extends State<OrganizerEventDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Detail"),
      ),
      body: Container(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Center(
            child: Image.memory(
              base64.decode(widget.data['event_image']),
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
                  widget.data['event_name'],
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
                        widget.data['duration'],
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
                        widget.data['location'],
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
                        widget.data['detail'],
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
                        widget.data['organizer']['first_name'] +
                            " " +
                            widget.data['organizer']['last_name'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.data['organizer']['phone'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.data['organizer']['email'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      "ความคืบหน้าการยื่นเรื่องอนุมัติ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TimelineTile(
                          axis: TimelineAxis.vertical,
                          alignment: TimelineAlign.manual,
                          lineXY: 0.1,
                          beforeLineStyle: LineStyle(
                            color: Colors.lightGreen
                          ),
                          indicatorStyle: IndicatorStyle(
                            color: Colors.lightGreen
                          ),
                          endChild: Container(
                            constraints: const BoxConstraints(
                              minHeight: 100,
                            ),
                            // color: Colors.lightGreenAccent,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("ยื่นหัวข้อกิจกรรม\nและเอกสารที่เกี่ยวข้อง"),
                            ),
                          ),
                          startChild: Container(
                            // color: Colors.amberAccent,
                          ),
                        ),
                        TimelineTile(
                          axis: TimelineAxis.vertical,
                          alignment: TimelineAlign.manual,
                          lineXY: 0.1,
                          beforeLineStyle: LineStyle(
                            color: Colors.lightGreen
                          ),
                          indicatorStyle: IndicatorStyle(
                            color: Colors.lightGreen
                          ),
                          endChild: Container(
                            constraints: const BoxConstraints(
                              minHeight: 100,
                            ),
                            // color: Colors.lightGreenAccent,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("ตรวจสอบเอกสาร"),
                            ),
                          ),
                          startChild: Container(
                            // color: Colors.amberAccent,
                          ),
                        ),
                        TimelineTile(
                          axis: TimelineAxis.vertical,
                          alignment: TimelineAlign.manual,
                          lineXY: 0.1,
                          beforeLineStyle: LineStyle(
                            color: widget.data['is_approved']
                              ? Colors.lightGreen
                              : widget.data['approved_by'] == 'none'
                                ? Colors.grey
                                : Colors.red
                          ),
                          indicatorStyle: IndicatorStyle(
                            color: widget.data['is_approved']
                              ? Colors.lightGreen
                              : widget.data['approved_by'] == 'none'
                                ? Colors.grey
                                : Colors.red
                          ),
                          isLast: true,
                          endChild: Container(
                            constraints: const BoxConstraints(
                              minHeight: 100,
                            ),
                            // color: Colors.lightGreenAccent,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: 
                              widget.data['is_approved']
                              ? Text("ได้รับการอนุมัติแล้ว")
                              : widget.data['approved_by'] == 'none'
                                ? Text("ได้รับการอนุมัติแล้ว")
                                : Text("เอกสารไม่ถูกต้อง"),
                            ),
                          ),
                          startChild: Container(
                            // color: Colors.amberAccent,
                          ),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                      ],
                    ),
                  ]))
        ],
      ))),
    );
  }
}
