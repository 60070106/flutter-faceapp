import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/camper/event_checkin.dart';
import 'package:kmitl64app/pages/camper/event_register.dart';
import 'package:kmitl64app/pages/login/signin_field_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  var data;
  var userdata;
  var eventAttendance;

  HomePage({this.data, this.userdata, this.eventAttendance});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _Page = 0;
  var _dataAvailiable = [];
  final picker = ImagePicker();

  void _getEventAttendance() async {
    var data = {"username": widget.userdata['username']};
    _dataAvailiable = [];

    var resDataAttendance =
        await CallApi().postData(data, 'event_camp_attendance/');
    var bodyDataAttendance = json.decode(resDataAttendance.body);

    var resHomepage = await CallApi().getData('get_all_event/');
    var bodyHomepage = json.decode(resHomepage.body);

    setState(() {
      widget.data = bodyHomepage;
      widget.eventAttendance = bodyDataAttendance;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
      } else {
        print('No image selected.');
      }
    });
  }

  Widget dataAttendance() {
    for (var i = 0; i < widget.data.length; i++) {
      if (widget.data[i]['is_approved'] == true) {
        _dataAvailiable.add(widget.data[i]);
      }
    }

    return (_Page == 0)
        ? Expanded(
            child: widget.data != null
                ? _dataAvailiable.length == 0
                    ? Container(
                        child: Padding(
                          child: Text(
                              "It's seem like you aren't registered any event yet.",
                              style: TextStyle(color: Colors.black38)),
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        ),
                      )
                    : CustomScrollView(primary: false, slivers: <Widget>[
                        SliverList(
                            delegate: SliverChildListDelegate(
                                List<Widget>.generate(_dataAvailiable.length,
                                    (index) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            SizedBox(
                                              child: InkWell(
                                                  splashColor:
                                                      Colors.amberAccent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20)),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        // color: Colors.red,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4885,
                                                        height: 200,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          15,
                                                                          7,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                  (index + 1)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                  _dataAvailiable[
                                                                          index]
                                                                      [
                                                                      'event_name'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                  (_dataAvailiable[index]['detail']
                                                                              .length >
                                                                          40)
                                                                      ? _dataAvailiable[index]['detail'].substring(0,
                                                                              40) +
                                                                          "..."
                                                                      : _dataAvailiable[
                                                                              index]
                                                                          [
                                                                          'detail'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
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
                                                        width: MediaQuery.of(
                                                                    context)
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
                                                              children: <
                                                                  Widget>[
                                                                ClipRRect(
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                8),
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                8)),
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.4,
                                                                      height:
                                                                          180,
                                                                      child: Image
                                                                          .memory(
                                                                        base64.decode(_dataAvailiable[index]
                                                                            [
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
                                                              EventRegisterPage(
                                                                  event_detail:
                                                                      _dataAvailiable[
                                                                          index])),
                                                    );

                                                    setState(() {});
                                                  }),
                                            )
                                          ],
                                        )
                                      ]))
                            ],
                          ));
                        })))
                      ])
                : Center(child: CircularProgressIndicator()))
        : Container();
  }

  Widget _dataAvaiable(String _isAvailable) {
    int _available = 0;
    if (_isAvailable == "available") {
      _available = 0;
    }
    if (_isAvailable == "coming") {
      _available = 1;
    }
    if (_isAvailable == "unavailable") {
      _available = 2;
    }

    return Column(
      children: List<Widget>.generate(
          widget.eventAttendance[_available][_isAvailable].length, (index) {
        return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                                  width: MediaQuery.of(context).size.width *
                                      0.4885,
                                  height: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 7, 0, 0),
                                        child: Text((index + 1).toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w200)),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        child: Text(
                                            widget.eventAttendance[_available]
                                                    [_isAvailable][index]
                                                ['event_name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        child: Text(
                                            (widget
                                                        .eventAttendance[_available][_isAvailable]
                                                            [index]['detail']
                                                        .length >
                                                    40)
                                                ? widget.eventAttendance[_available]
                                                            [_isAvailable]
                                                            [index]['detail']
                                                        .substring(0, 40) +
                                                    "..."
                                                : widget.eventAttendance[_available]
                                                        [_isAvailable][index]
                                                    ['detail'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal)),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 200,
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8)),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: 180,
                                                child: Image.memory(
                                                  base64.decode(
                                                      widget.eventAttendance[
                                                                      _available]
                                                                  [_isAvailable]
                                                              [index]
                                                          ['event_image']),
                                                  fit: BoxFit.fitHeight,
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
                              setState(() {});

                              var data = {
                                "organizer": widget.eventAttendance[_available]
                                    [_isAvailable][index]['organizer']
                              };

                              var res = await CallApi()
                                  .postData(data, 'event_get_detail/');
                              var body = jsonDecode(res.body);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventCheckPage(
                                        state: _isAvailable,
                                        organizer_data: body,
                                        event_detail:
                                            widget.eventAttendance[_available]
                                                [_isAvailable][index])),
                              );

                              setState(() {});
                            }),
                      )
                    ],
                  )
                ]));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.eventAttendance);
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  title: Text("Event Calendar"),
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
                    Tab(text: "Event Available", icon: Icon(Icons.person)),
                    // Tab(text: "Create Event", icon: Icon(Icons.add)),
                    Tab(
                        text: "Event Attendance",
                        icon: Icon(Icons.play_for_work_outlined))
                  ]),
                  backgroundColor: Color(0xFFFC663C)),
              body: TabBarView(children: [
                Container(
                  child: Column(children: <Widget>[dataAttendance()]),
                ),
                SingleChildScrollView(
                  child: Column(
                      children: widget.eventAttendance != null
                          ? (widget.eventAttendance[0]['available'].length ==
                                      0 &&
                                  widget.eventAttendance[1]['coming'].length ==
                                      0 &&
                                  widget.eventAttendance[2]['unavailable']
                                          .length ==
                                      0)
                              ? <Widget>[
                                  Padding(
                                    child: Text(
                                        "It's seem like you aren't registered any event yet.",
                                        style:
                                            TextStyle(color: Colors.black38)),
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  ),
                                ]
                              : <Widget>[
                                  Padding(
                                    child: Text(
                                      "Now running...",
                                    ),
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  ),
                                  widget.eventAttendance[0]['available']
                                              .length ==
                                          0
                                      ? Container(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Text(
                                              "No event that running right now.",
                                              style: TextStyle(
                                                  color: Colors.black38)),
                                        )
                                      : _dataAvaiable('available'),
                                  Container(
                                    height: 50,
                                  ),
                                  Divider(),
                                  Padding(
                                    child: Text(
                                      "Coming soon...",
                                    ),
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  ),
                                  widget.eventAttendance[1]['coming'].length ==
                                          0
                                      ? Container(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Text(
                                            "No event here, try to register some event?",
                                            style: TextStyle(
                                                color: Colors.black38),
                                          ),
                                        )
                                      : _dataAvaiable('coming'),
                                  Container(
                                    height: 50,
                                  ),
                                  Divider(),
                                  Padding(
                                    child: Text(
                                      "Already finished",
                                    ),
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  ),
                                  widget.eventAttendance[2]['unavailable']
                                              .length ==
                                          0
                                      ? Container(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Text(
                                              "No event that already finished yet.",
                                              style: TextStyle(
                                                  color: Colors.black38)),
                                        )
                                      : _dataAvaiable('unavailable'),
                                  Container(
                                    height: 50,
                                  ),
                                ]
                          : <Widget>[
                              Center(child: CircularProgressIndicator())
                            ]),
                ),
              ]),
            )));
  }
}
