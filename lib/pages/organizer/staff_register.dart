import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/organizer/event_edit.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'attendance_detail_page.dart';

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
                          beforeLineStyle: LineStyle(color: Colors.lightGreen),
                          afterLineStyle: LineStyle(
                              color: widget.data['is_approved']
                                  ? Colors.lightGreen
                                  : widget.data['approved_by'] == 'none'
                                      ? Colors.yellow
                                      : Colors.orange),
                          indicatorStyle:
                              IndicatorStyle(color: Colors.lightGreen),
                          endChild: Container(
                            constraints: const BoxConstraints(
                              minHeight: 100,
                            ),
                            // color: Colors.lightGreenAccent,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  "ยื่นหัวข้อกิจกรรม\nและเอกสารที่เกี่ยวข้อง"),
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
                                      ? Colors.yellow
                                      : Colors.orange),
                          afterLineStyle: LineStyle(
                              color: widget.data['is_approved']
                                  ? Colors.lightGreen
                                  : Colors.grey),
                          indicatorStyle: IndicatorStyle(
                              color: widget.data['is_approved']
                                  ? Colors.lightGreen
                                  : widget.data['approved_by'] == 'none'
                                      ? Colors.yellow
                                      : Colors.orange),
                          endChild: Column(
                            children: [
                              widget.data['is_approved']
                                  ? Container(
                                      height: 40,
                                    )
                                  : Container(),
                              Container(
                                // constraints: const BoxConstraints(
                                //   minHeight: 100,
                                // ),
                                // color: Colors.lightGreenAccent,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    children: [
                                      widget.data['is_approved']
                                          ? Text("เอกสารและรายละเอียดถูกต้อง")
                                          : widget.data['approved_by'] == 'none'
                                              ? Text(
                                                  "ตรวจสอบรายละเอียด\nและเอกสารที่เกี่ยวข้อง")
                                              : Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "รายละเอียดไม่ถูกต้อง",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text("ข้อคิดเห็น: " +
                                                            widget.data[
                                                                'approved_detail']),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: FlatButton(
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              8,
                                                                          bottom:
                                                                              8,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                  child: Text(
                                                                    'แก้ไข',
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              color: Colors
                                                                  .orangeAccent,
                                                              disabledColor:
                                                                  Colors.grey,
                                                              shape: new RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          20.0)),
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                    context,
                                                                    new MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                EditEventPage(data: widget.data)));
                                                              }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // startChild: Container(
                          //   // color: Colors.amberAccent,
                          // ),
                        ),
                        TimelineTile(
                          axis: TimelineAxis.vertical,
                          alignment: TimelineAlign.manual,
                          lineXY: 0.1,
                          beforeLineStyle: LineStyle(
                              color: widget.data['is_approved']
                                  ? Colors.lightGreen
                                  : Colors.grey),
                          indicatorStyle: IndicatorStyle(
                              color: widget.data['is_approved']
                                  ? Colors.lightGreen
                                  : Colors.grey),
                          isLast: true,
                          endChild: Container(
                            constraints: const BoxConstraints(
                              minHeight: 100,
                            ),
                            // color: Colors.lightGreenAccent,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text("ได้รับการอนุมัติแล้ว")),
                          ),
                          startChild: Container(
                              // color: Colors.amberAccent,
                              ),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                      ],
                    ),
                    widget.data['is_approved'] ?
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: FlatButton(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                child: Text(
                                  'ดูประวัติการลงชื่อเข้า-ออก',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            color: Colors.blueAccent,
                            disabledColor: Colors.grey,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)),
                            onPressed: () async {

                              var eventName = {"event_name" : widget.data['event_name']};
                              var res = await CallApi()
                                          .postData(eventName, 'event_attendance_detail/');
                              var body = json.decode(res.body);

                              print(body);

                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          AttendanceDetailPage(data: body)));
                            }),
                      ),
                    )
                    : Container()
                  ]))
        ],
      ))),
    );
  }
}
