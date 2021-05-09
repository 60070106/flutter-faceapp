import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/approver/checkdetail_page.dart';
import 'package:kmitl64app/pages/login/signin_field_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentCheckPage extends StatefulWidget {
  var data;
  var user;
  DocumentCheckPage({this.data, this.user});

  @override
  _DocumentCheckPageState createState() => _DocumentCheckPageState();
}

class _DocumentCheckPageState extends State<DocumentCheckPage> {
  var _checkedEvent = [];

  void _getEventAttendance() async {
    _checkedEvent = [];

    var resHomepage = await CallApi().getData('get_all_event/');
    var bodyHomepage = json.decode(resHomepage.body);

    setState(() {
      widget.data = bodyHomepage;
    });
  }

  Widget allEvent() {
    return Expanded(
        child: widget.data != null
            ? CustomScrollView(primary: false, slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(
                        List<Widget>.generate(widget.data.length, (index) {
                  return Container(
                      child: Column(
                    children: <Widget>[
                      Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 3.5,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    SizedBox(
                                      child: InkWell(
                                          splashColor: Colors.amberAccent,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                // color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4885,
                                                height: 200,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 7, 0, 0),
                                                      child: Text(
                                                          (index + 1)
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          widget.data[index]
                                                              ['event_name'],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          (widget
                                                                      .data[index]
                                                                          [
                                                                          'detail']
                                                                      .length >
                                                                  40)
                                                              ? widget.data[index]
                                                                          [
                                                                          'detail']
                                                                      .substring(
                                                                          0,
                                                                          40) +
                                                                  "..."
                                                              : widget.data[index]
                                                                  ['detail'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    // _isLoading
                                                    // ? Container(
                                                    //   // color: Colors.green,
                                                    //   padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                                    //   child: Center(child: CircularProgressIndicator(),),
                                                    // )
                                                    // : Container(),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // color: Colors.amber,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: 200,
                                                child: Row(
                                                  children: <Widget>[
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.2639,
                                                              child:
                                                                  Image.memory(
                                                                base64.decode(widget
                                                                            .data[
                                                                        index][
                                                                    'event_image']),
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckDocumentDetailPage(
                                                          data: widget
                                                              .data[index])),
                                            );
                                          }),
                                    )
                                  ],
                                )
                              ]))
                    ],
                  ));
                })))
              ])
            : Center(child: CircularProgressIndicator()));
  }

  Widget checkedEvent() {
    _checkedEvent = [];

    for (var i = 0; i < widget.data.length; i++) {
      if (widget.data[i]['approved_by'] == widget.user['username']) {
        _checkedEvent.add(widget.data[i]);
      }
    }

    return Expanded(
        child: widget.data != null
            ? _checkedEvent.length == 0
              ? Container(
                        child: Padding(
                          child: Text(
                              "It's seem like you aren't approve any event yet.",
                              style: TextStyle(color: Colors.black38)),
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        ),
                      )
              : CustomScrollView(primary: false, slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(
                        List<Widget>.generate(_checkedEvent.length, (index) {
                  return Container(
                      child: Column(
                    children: <Widget>[
                      Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 3.5,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    SizedBox(
                                      child: InkWell(
                                          splashColor: Colors.amberAccent,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                // color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4885,
                                                height: 200,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 7, 0, 0),
                                                      child: Text(
                                                          (index + 1)
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          _checkedEvent[index]
                                                              ['event_name'],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          (_checkedEvent[index]
                                                                          [
                                                                          'detail']
                                                                      .length >
                                                                  40)
                                                              ? _checkedEvent[index]
                                                                          [
                                                                          'detail']
                                                                      .substring(
                                                                          0,
                                                                          40) +
                                                                  "..."
                                                              : _checkedEvent[index]
                                                                  ['detail'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    // _isLoading
                                                    // ? Container(
                                                    //   // color: Colors.green,
                                                    //   padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                                    //   child: Center(child: CircularProgressIndicator(),),
                                                    // )
                                                    // : Container(),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // color: Colors.amber,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: 200,
                                                child: Row(
                                                  children: <Widget>[
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.2639,
                                                              child:
                                                                  Image.memory(
                                                                base64.decode(_checkedEvent[
                                                                        index][
                                                                    'event_image']),
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckDocumentDetailPage(
                                                          data: _checkedEvent[index])),
                                            );
                                          }),
                                    )
                                  ],
                                )
                              ]))
                    ],
                  ));
                })))
              ])
            : Center(child: CircularProgressIndicator()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                  title: Text("ส่วนตรวจสอบเอกสาร"),
                  backgroundColor: Color(0xFF876aa4),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          _getEventAttendance();
                        }),
                    IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () async {
                          SharedPreferences localStorage =
                              await SharedPreferences.getInstance();
                          localStorage.clear();
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInPage()),
                          );
                        })
                  ],
                  bottom:
                      TabBar(indicatorColor: Colors.amberAccent, tabs: <Tab>[
                    Tab(text: "กิจกรรมทั้งหมด", icon: Icon(Icons.event)),
                    // Tab(text: "Create Event", icon: Icon(Icons.add)),
                    Tab(
                        text: "กิจกรรมที่ตรวจสอบแล้ว",
                        icon: Icon(Icons.play_for_work_outlined))
                  ])),
              body: TabBarView(children: [
                Container(child: Column(children: <Widget>[allEvent()])),
                Container(child: Column(children: <Widget>[checkedEvent()]))
              ]),
            )));
  }
}
