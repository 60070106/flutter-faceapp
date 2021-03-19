import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/home/event_checkin.dart';
import 'package:kmitl64app/pages/home/event_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event_confirm.dart';

class HomePage extends StatefulWidget {
  var data;
  var userdata;
  var eventAttendance;

  HomePage({this.data, this.userdata, this.eventAttendance});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  int _Page = 0;
  bool _isLoading = false;
  final picker = ImagePicker();

  DateTime selectedDate = DateTime.now();

  TextEditingController locationController = TextEditingController();
  TextEditingController eventStartController = TextEditingController();
  TextEditingController eventEndController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    _getEventAttendance();
    super.initState();
  }

  void _getEventAttendance() async {
    var data = {"username": widget.userdata['username']};

    var resDataAttendance =
        await CallApi().postData(data, 'event/camp/attendance/');
    var bodyDataAttendance = json.decode(resDataAttendance.body);

    var resHomepage = await CallApi().getData('event/get_all_event/');
    var bodyHomepage = json.decode(resHomepage.body);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('data', json.encode(bodyHomepage));
    localStorage.setString('attendance', json.encode(bodyDataAttendance));

    setState(() {
      widget.data = bodyHomepage;
      widget.eventAttendance = bodyDataAttendance;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        eventStartController.text = picked.toString().substring(0, 10);
        selectedDate = picked;
      });
  }

  _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        eventEndController.text = picked.toString().substring(0, 10);
        selectedDate = picked;
      });
  }

  Widget dataAttendance() {
    return (_Page == 0)
        ? Expanded(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          child: InkWell(
                                              splashColor: Colors.amberAccent,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20)),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    // color: Colors.red,
                                                    width:
                                                        MediaQuery.of(context)
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
                                                          padding: EdgeInsets
                                                              .fromLTRB(
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
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  20, 0, 0, 0),
                                                          child: Text(
                                                              widget.data[index]
                                                                  [
                                                                  'event_name'],
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  20, 0, 0, 0),
                                                          child: Text(
                                                              (widget
                                                                          .data[index]
                                                                              [
                                                                              'detail']
                                                                          .length >
                                                                      40)
                                                                  ? widget.data[index]['detail']
                                                                          .substring(
                                                                              0,
                                                                              40) +
                                                                      "..."
                                                                  : widget.data[
                                                                          index]
                                                                      [
                                                                      'detail'],
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
                                                    width:
                                                        MediaQuery.of(context)
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
                                                                        Radius.circular(
                                                                            8)),
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.4,
                                                                  height: 180,
                                                                  child: Image
                                                                      .memory(
                                                                    base64.decode(
                                                                        widget.data[index]
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
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                var data = {
                                                  "organizer": widget
                                                      .data[index]['organizer']
                                                };

                                                var res = await CallApi()
                                                    .postData(data,
                                                        'event/get/detail/');
                                                var body = jsonDecode(res.body);

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EventRegisterPage(
                                                              organizer_data:
                                                                  body,
                                                              event_detail:
                                                                  widget.data[
                                                                      index])),
                                                );

                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }),
                                        )
                                      ],
                                    )
                                  ]))
                        ],
                      ));
                    })))
                  ])
                : CircularProgressIndicator())
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
                              setState(() {
                                _isLoading = true;
                              });

                              var data = {
                                "organizer": widget.eventAttendance[_available]
                                    [_isAvailable][index]['organizer']
                              };

                              var res = await CallApi()
                                  .postData(data, 'event/get/detail/');
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

                              setState(() {
                                _isLoading = false;
                              });
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
            length: 3,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                  title: Text("Event Calendar"),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          _getEventAttendance();
                        })
                  ],
                  bottom:
                      TabBar(indicatorColor: Colors.amberAccent, tabs: <Tab>[
                    Tab(text: "Event Available", icon: Icon(Icons.person)),
                    Tab(text: "Create Event", icon: Icon(Icons.add)),
                    Tab(
                        text: "Event Attendance",
                        icon: Icon(Icons.play_for_work_outlined))
                  ]),
                  backgroundColor: Color(0xFFFC663C)),
              body: TabBarView(children: [
                Container(
                  child: Column(children: <Widget>[
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.1,
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: <Widget>[
                    //         RaisedButton(
                    //             child: Text(
                    //               "All",
                    //               style: TextStyle(color: Colors.white),
                    //             ),
                    //             color: Colors.deepPurple,
                    //             onPressed: () {
                    //               setState(() {
                    //                 // _Page = 0;
                    //               });
                    //             }),
                    //       ]),
                    // ),
                    dataAttendance()
                  ]),
                ),
                Center(
                  child: Container(
                      height: 600,
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Center(
                                child: Column(
                              children: <Widget>[
                                ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    child: _image != null
                                        ? Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8)),
                                                child: Image(
                                                  fit: BoxFit.fitWidth,
                                                  image: FileImage(_image),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    stops: [0, 0.5],
                                                    colors: [
                                                      const Color(0xA8000000),
                                                      const Color(0x00FFFFFF)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      getImage();
                                                    },
                                                    splashColor: Colors.black26,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                child: Material(
                                                  color: Colors.grey[200],
                                                  child: InkWell(
                                                    onTap: () {
                                                      getImage();
                                                    },
                                                    splashColor: Colors.black26,
                                                  ),
                                                ),
                                              ),
                                              Icon(Icons.camera_alt,
                                                  color: Colors.grey[800]),
                                              Container(
                                                height: 75,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Text(
                                                    "กรุณาใส่รูปภาพประกอบกิจกรรม"),
                                              )
                                            ],
                                          )),
                                Column(
                                  children: <Widget>[
                                    TextField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      controller: eventNameController,
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.event,
                                          color: Colors.grey,
                                        ),
                                        hintText: "กรุณาใส่ชื่อกิจกรรม",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    TextField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      controller: eventStartController,
                                      onTap: () {
                                        _selectStartDate(context);
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.grey,
                                        ),
                                        hintText: "กรุณาวันที่เริ่มต้นกิจกรรม",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    TextField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      controller: eventEndController,
                                      onTap: () {
                                        _selectEndDate(context);
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.arrow_upward,
                                          color: Colors.grey,
                                        ),
                                        hintText: "กรุณาวันที่สิ้นสุดกิจกรรม",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    TextField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      controller: locationController,
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.place,
                                          color: Colors.grey,
                                        ),
                                        hintText: "กรุณาใส่สถานที่กิจกรรม",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    TextField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      controller: detailController,
                                      cursorColor: Color(0xFF9b9b9b),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.text_snippet_rounded),
                                        hintText: "กรุณาใส่รายละเอียด",
                                        hintStyle: TextStyle(
                                            // height: 3.5,
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: FlatButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10),
                                            child: Text(
                                              'Create Event',
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
                                                  new BorderRadius.circular(
                                                      20.0)),
                                          onPressed: () async {
                                            SharedPreferences localStorage =
                                                await SharedPreferences
                                                    .getInstance();
                                            var userJson =
                                                localStorage.getString('user');
                                            var user = json.decode(userJson);

                                            String base64Image = base64Encode(
                                                _image.readAsBytesSync());

                                            var EventData = {
                                              'imgevent': base64Image,
                                              'organizer': user['username'],
                                              'location':
                                                  locationController.text,
                                              'duration':
                                                  eventStartController.text +
                                                      " - " +
                                                      eventEndController.text,
                                              'event_name':
                                                  eventNameController.text,
                                              'detail': detailController.text,
                                              'imgpath': '',
                                            };

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventConfirmPage(
                                                        data: EventData,
                                                        userdata: user,
                                                      )
                                                  // builder: (context) => TestMyApp(),
                                                  ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                          ],
                        ),
                      )),
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
                          : <Widget>[CircularProgressIndicator()]),
                ),
              ]),
            )));
  }
}
