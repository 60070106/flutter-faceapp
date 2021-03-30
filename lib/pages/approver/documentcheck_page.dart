import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmitl64app/pages/approver/checkdetail_page.dart';

class DocumentCheckPage extends StatefulWidget {
  var data;
  DocumentCheckPage({this.data});

  @override
  _DocumentCheckPageState createState() => _DocumentCheckPageState();
}

class _DocumentCheckPageState extends State<DocumentCheckPage> {
  Widget dataAttendance() {
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
                                                                        8),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            8)),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              height: 180,
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
                                                          data: widget.data[index])),
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
                  title: Text("Document Checking"),
                  bottom:
                      TabBar(indicatorColor: Colors.amberAccent, tabs: <Tab>[
                    Tab(text: "All Event", icon: Icon(Icons.event)),
                    // Tab(text: "Create Event", icon: Icon(Icons.add)),
                    Tab(
                        text: "Checked Event",
                        icon: Icon(Icons.play_for_work_outlined))
                  ])),
              body: TabBarView(children: [
                Container(child: Column(children: <Widget>[dataAttendance()])),
                Container()
              ]),
            )));
  }
}
