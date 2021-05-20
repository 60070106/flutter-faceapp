import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/login/signin_field_page.dart';
import 'package:kmitl64app/pages/organizer/staff_register.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event_confirm.dart';

class OrganizerPage extends StatefulWidget {
  var data;
  OrganizerPage({this.data});

  @override
  _OrganizerPageState createState() => _OrganizerPageState();
}

class _OrganizerPageState extends State<OrganizerPage> {
  File _image;
  bool _isLoading = false;
  int _Page = 0;
  var _availiable = [];
  var _unavailiable = [];
  final picker = ImagePicker();

  DateTime selectedDate = DateTime.now();

  TextEditingController locationController = TextEditingController();
  TextEditingController eventStartController = TextEditingController();
  TextEditingController eventEndController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _hasValidMime = false;
  FileType _pickingType;

  void _getEventAttendance() async {
    var resHomepage = await CallApi().getData('get_all_event/');
    var bodyHomepage = json.decode(resHomepage.body);

    setState(() {
      widget.data = bodyHomepage;
    });
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType, fileExtension: _extension);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;
      // print("-------------------------------------------------------------");
      // _paths.forEach((k, v) {
      //   File file = File(v);
      //   // Uint8List bytes = file.readAsBytesSync();
      //   String base64Pdf = base64Encode(file.readAsBytesSync());
      //   print(base64Pdf);
      // });

      setState(() {
        _loadingPath = false;
      });
    }
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
    for (var i = 0; i < widget.data.length; i++) {
      if (widget.data[i]['is_approved'] == true) {
        _availiable.add(widget.data[i]);
      } else {
        _unavailiable.add(widget.data[i]);
      }
    }

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
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                child:
                                                                    Container(
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
                                                SharedPreferences localStorage =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var userJson = localStorage
                                                    .getString('user');
                                                var user =
                                                    json.decode(userJson);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrganizerEventDetailPage(
                                                                username: user['username'],
                                                                data:
                                                                    widget.data[
                                                                        index])
                                                        // builder: (context) => TestMyApp(),
                                                        ),
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
                : Center(child: CircularProgressIndicator()))
        : _Page == 1
            ? widget.data != null
                ? _availiable.length == 0
                    ? Center(
                        child: Text("No event approved yet."),
                      )
                    : Expanded(
                        child: CustomScrollView(
                            primary: false,
                            slivers: <Widget>[
                              SliverList(
                                  delegate: SliverChildListDelegate(
                                      List<Widget>.generate(_availiable.length,
                                          (index) {
                                return Container(
                                    child: Column(
                                  children: <Widget>[
                                    Card(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
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
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets
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
                                                                                FontWeight.w200)),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                        _availiable[index]
                                                                            [
                                                                            'event_name'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                        (_availiable[index]['detail'].length > 40)
                                                                            ? _availiable[index]['detail'].substring(0, 40) +
                                                                                "..."
                                                                            : _availiable[index][
                                                                                'detail'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.normal)),
                                                                  ),
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
                                                                children: <
                                                                    Widget>[
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
                                                                              topRight: Radius.circular(8),
                                                                              bottomRight: Radius.circular(8)),
                                                                          child: Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.4,
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.2639,
                                                                            child:
                                                                                Image.memory(
                                                                              base64.decode(_availiable[index]['event_image']),
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
                                                          SharedPreferences
                                                              localStorage =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          var userJson =
                                                              localStorage
                                                                  .getString(
                                                                      'user');
                                                          var user = json
                                                              .decode(userJson);

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      OrganizerEventDetailPage(
                                                                          username: user['username'],
                                                                          data:
                                                                              _availiable[index])
                                                                  // builder: (context) => TestMyApp(),
                                                                  ),
                                                            );
                                                        }),
                                                  )
                                                ],
                                              )
                                            ]))
                                  ],
                                ));
                              })))
                            ]),
                      )
                : Center(child: CircularProgressIndicator())
            : _Page == 2
                ? widget.data != null
                    ? _unavailiable.length == 0
                        ? Center(
                            child: Text("No event unapproved yet."),
                          )
                        : Expanded(
                            child: CustomScrollView(
                                primary: false,
                                slivers: <Widget>[
                                  SliverList(
                                      delegate: SliverChildListDelegate(
                                          List<Widget>.generate(
                                              _unavailiable.length, (index) {
                                    return Container(
                                        child: Column(
                                      children: <Widget>[
                                        Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            elevation: 3.5,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Stack(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        child: InkWell(
                                                            splashColor: Colors
                                                                .amberAccent,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
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
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            15,
                                                                            7,
                                                                            0,
                                                                            0),
                                                                        child: Text(
                                                                            (index + 1)
                                                                                .toString(),
                                                                            style:
                                                                                TextStyle(fontSize: 10, fontWeight: FontWeight.w200)),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            20,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child: Text(
                                                                            _unavailiable[index][
                                                                                'event_name'],
                                                                            style:
                                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            20,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child: Text(
                                                                            (_unavailiable[index]['detail'].length > 40)
                                                                                ? _unavailiable[index]['detail'].substring(0, 40) + "..."
                                                                                : _unavailiable[index]['detail'],
                                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                                                                      ),
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
                                                                    children: <
                                                                        Widget>[
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: <
                                                                            Widget>[
                                                                          ClipRRect(
                                                                              borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                                              child: Container(
                                                                                width: MediaQuery.of(context).size.width * 0.4,
                                                                                height: MediaQuery.of(context).size.height * 0.2639,
                                                                                child: Image.memory(
                                                                                  base64.decode(_unavailiable[index]['event_image']),
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
                                                              SharedPreferences
                                                                  localStorage =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              var userJson =
                                                                  localStorage
                                                                      .getString(
                                                                          'user');
                                                              var user =
                                                                  json.decode(
                                                                      userJson);

                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          OrganizerEventDetailPage(
                                                                            username: user['username'],
                                                                              data: _unavailiable[index])
                                                                      // builder: (context) => TestMyApp(),
                                                                      ),
                                                                );
                                                              
                                                            }),
                                                      )
                                                    ],
                                                  )
                                                ]))
                                      ],
                                    ));
                                  })))
                                ]),
                          )
                    : Center(child: CircularProgressIndicator())
                : Center(child: Text("Is this a bug??"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  title: Text("ส่วนจัดการกิจกรรม"),
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
                    Tab(text: "สร้างกิจกรรมใหม่", icon: Icon(Icons.add))
                  ])),
              body: TabBarView(children: [
                Center(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          // color: Colors.yellow,
                          // width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFF6b6272))),
                                    onPressed: () async {
                                      setState(() {
                                        _availiable = [];
                                        _unavailiable = [];
                                        _Page = 0;
                                      });
                                    },
                                    child: Text("ทั้งหมด")),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFF6b6272))),
                                    onPressed: () async {
                                      setState(() {
                                        _availiable = [];
                                        _unavailiable = [];
                                        _Page = 1;
                                      });
                                    },
                                    child: Text("อนุมัติแล้ว")),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFF6b6272))),
                                    onPressed: () async {
                                      setState(() {
                                        _availiable = [];
                                        _unavailiable = [];
                                        _Page = 2;
                                      });
                                    },
                                    child: Text("ยังไม่อนุมัติ")),
                              )
                            ],
                          ),
                        ),
                      ),
                      dataAttendance()
                    ],
                  ),
                ),
                Center(
                  child: Expanded(
                      child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
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
                                                  topRight: Radius.circular(8)),
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
                                                  begin: Alignment.bottomCenter,
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
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                  "กรุณาใส่รูปภาพประกอบกิจกรรม"),
                                            )
                                          ],
                                        )),
                              Column(
                                children: <Widget>[
                                  TextField(
                                    style: TextStyle(color: Color(0xFF000000)),
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
                                    style: TextStyle(color: Color(0xFF000000)),
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
                                    style: TextStyle(color: Color(0xFF000000)),
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
                                    style: TextStyle(color: Color(0xFF000000)),
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
                                    style: TextStyle(color: Color(0xFF000000)),
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
                                      padding: const EdgeInsets.only(
                                          top: 30.0, bottom: 10.0),
                                      child: FlatButton(
                                          onPressed: () => _openFileExplorer(),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10),
                                            child: Text(
                                              'อัพโหลดเอกสารที่เกี่ยวข้อง',
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          color: Colors.blueGrey,
                                          disabledColor: Colors.grey,
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)))),
                                  _loadingPath
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child:
                                              const CircularProgressIndicator())
                                      : _paths != null
                                          ? Column(
                                              children: [
                                                Container(
                                                    child: _paths.length != 0
                                                        ? Column(
                                                            children: List<
                                                                    Widget>.generate(
                                                                _paths.length,
                                                                (index) {
                                                              final String
                                                                  name =
                                                                  'File ' +
                                                                      (index +
                                                                              1)
                                                                          .toString() +
                                                                      ': ' +
                                                                      _paths.keys
                                                                              .toList()[
                                                                          index];
                                                              final path = _paths
                                                                  .values
                                                                  .toList()[
                                                                      index]
                                                                  .toString();
                                                              return Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    name,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(path),
                                                                  Center(
                                                                      child: PdfDocumentLoader
                                                                          .openData(
                                                                    base64.decode(
                                                                        base64Encode(
                                                                            File(path).readAsBytesSync())),
                                                                    documentBuilder: (context,
                                                                            pdfDocument,
                                                                            pageCount) =>
                                                                        LayoutBuilder(
                                                                            builder: (context, constraints) =>
                                                                                Container(
                                                                                  height: MediaQuery.of(context).size.height * 0.65,
                                                                                  child: ListView.builder(
                                                                                      shrinkWrap: true,
                                                                                      itemCount: pageCount,
                                                                                      itemBuilder: (context, index) => Container(
                                                                                          margin: EdgeInsets.all(8),
                                                                                          padding: EdgeInsets.all(8),
                                                                                          color: Colors.black12,
                                                                                          child: PdfPageView(
                                                                                            pdfDocument: pdfDocument,
                                                                                            pageNumber: index + 1,
                                                                                          ))),
                                                                                )),
                                                                  )),
                                                                  Divider()
                                                                ],
                                                              );
                                                            }),
                                                          )
                                                        : Container()),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: FlatButton(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8,
                                                                bottom: 8,
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          'สร้างกิจกรรม',
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15.0,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ),
                                                      color: Colors.red,
                                                      disabledColor:
                                                          Colors.grey,
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  20.0)),
                                                      onPressed: () async {
                                                        SharedPreferences
                                                            localStorage =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        var userJson =
                                                            localStorage
                                                                .getString(
                                                                    'user');
                                                        var user = json
                                                            .decode(userJson);

                                                        String base64Image =
                                                            base64Encode(_image
                                                                .readAsBytesSync());

                                                        var documentList = [];
                                                        // print(documentList);

                                                        _paths.forEach((k, v) {
                                                          File file = File(v);
                                                          String base64Pdf =
                                                              base64Encode(file
                                                                  .readAsBytesSync());
                                                          var dataPDf = {
                                                            "data": base64Pdf
                                                          };
                                                          documentList
                                                              .add(dataPDf);
                                                        });

                                                        // print(documentList);

                                                        var eventData = {
                                                          'imgevent':
                                                              base64Image,
                                                          'organizer':
                                                              user['username'],
                                                          'location':
                                                              locationController
                                                                  .text,
                                                          'duration':
                                                              eventStartController
                                                                      .text +
                                                                  " - " +
                                                                  eventEndController
                                                                      .text,
                                                          'event_name':
                                                              eventNameController
                                                                  .text,
                                                          'detail':
                                                              detailController
                                                                  .text,
                                                          'documents':
                                                              documentList,
                                                          'imgpath': '',
                                                        };

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EventConfirmPage(
                                                                    data:
                                                                        eventData,
                                                                    userdata:
                                                                        user,
                                                                  )),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                ],
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  )),
                ),
              ]),
            )));
  }
}
