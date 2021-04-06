import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmitl64app/api.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEventPage extends StatefulWidget {
  var data;
  EditEventPage({this.data});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  bool _initData = false;
  bool _loadingPath = false;
  bool _loading = false;

  Map<String, String> _paths;
  String _extension;
  bool _hasValidMime = false;
  FileType _pickingType;

  final picker = ImagePicker();
  DateTime selectedDate = DateTime.now();

  TextEditingController locationController = TextEditingController();
  TextEditingController eventStartController = TextEditingController();
  TextEditingController eventEndController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() {
        _loadingPath = true;
      });
      widget.data['documents'] = [];

      try {
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType, fileExtension: _extension);

        _paths.forEach((k, v) {
          File file = File(v);
          String base64Pdf = base64Encode(file.readAsBytesSync());
          var dataPDf = {"data": base64Pdf};
          widget.data['documents'].add(dataPDf);
        });
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
        widget.data['event_image'] =
            base64Encode(File(pickedFile.path).readAsBytesSync());
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

  @override
  Widget build(BuildContext context) {
    _initData
        ? setState(() {
            _initData = true;
          })
        : setState(() {
            locationController.text = widget.data['location'];
            eventStartController.text = widget.data['duration'].substring(0, 10);
            eventEndController.text = widget.data['duration'].substring(13);
            eventNameController.text = widget.data['event_name'];
            detailController.text = widget.data['detail'];
            _initData = true;
          });

    return Scaffold(
      appBar: AppBar(
        title: Text("Event edition"),
      ),
      body: Center(
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
                        child: widget.data['event_image'] != null
                            ? Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    child: Image.memory(
                                      base64.decode(widget.data['event_image']),
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
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
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
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
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
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
                                    child: Text("กรุณาใส่รูปภาพประกอบกิจกรรม"),
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
                            prefixIcon: Icon(Icons.text_snippet_rounded),
                            hintText: "กรุณาใส่รายละเอียด",
                            hintStyle: TextStyle(
                                // height: 3.5,
                                color: Color(0xFF9b9b9b),
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 10.0),
                            child: FlatButton(
                                onPressed: () => _openFileExplorer(),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
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
                                        new BorderRadius.circular(20.0)))),
                        _loadingPath
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: const CircularProgressIndicator())
                            : widget.data['documents'].length != 0
                                ? Container(
                                    child: widget.data['documents'].length != 0
                                        ? Column(
                                            children: List<Widget>.generate(
                                                widget.data['documents'].length,
                                                (index) {
                                              final String name = 'File ' +
                                                  (index + 1).toString() +
                                                  ":";

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Center(
                                                      child: PdfDocumentLoader
                                                          .openData(
                                                    base64.decode(
                                                        widget.data['documents']
                                                            [index]['data']),
                                                    documentBuilder: (context,
                                                            pdfDocument,
                                                            pageCount) =>
                                                        LayoutBuilder(
                                                            builder: (context,
                                                                    constraints) =>
                                                                Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.62,
                                                                  child: ListView.builder(
                                                                      shrinkWrap: true,
                                                                      itemCount: pageCount,
                                                                      itemBuilder: (context, index) => Container(
                                                                          margin: EdgeInsets.all(8),
                                                                          padding: EdgeInsets.all(8),
                                                                          color: Colors.black12,
                                                                          child: PdfPageView(
                                                                            pdfDocument:
                                                                                pdfDocument,
                                                                            pageNumber:
                                                                                index + 1,
                                                                          ))),
                                                                )),
                                                  )),
                                                  Divider()
                                                ],
                                              );
                                            }),
                                          )
                                        : Container())
                                : Container(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FlatButton(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                child: Text(
                                  _loading ? 'Editing...' : 'Edit Event',
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
                              onPressed: _loading
                                  ? null
                                  : () async {
                                      setState(() {
                                        _loading = true;
                                      });

                                      SharedPreferences localStorage =
                                          await SharedPreferences.getInstance();
                                      var userJson =
                                          localStorage.getString('user');
                                      var user = json.decode(userJson);

                                      var editData = {
                                        "username": user['username'],
                                        "event_name": widget.data['event_name'],
                                        "eventname": eventNameController.text,
                                        "duration": eventStartController.text +
                                            " - " +
                                            eventEndController.text,
                                        "location": locationController.text,
                                        "detail": detailController.text,
                                        "event_image":
                                            widget.data['event_image'],
                                        "documents": widget.data['documents']
                                      };

                                      var res = await CallApi()
                                          .postData(editData, 'event/edit/');
                                      var body = json.decode(res.body);

                                      print(body);

                                      setState(() {
                                        _loading = false;
                                      });
                                    }),
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
        )),
      ),
    );
  }
}
