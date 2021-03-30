import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmitl64app/api.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../camper/home_page.dart';
import 'home.dart';

class EventConfirmPage extends StatefulWidget {
  var data;
  var userdata;

  EventConfirmPage({this.data, this.userdata});

  @override
  _EventConfirmPageState createState() => _EventConfirmPageState();
}

class _EventConfirmPageState extends State<EventConfirmPage> {
  File _image;
  bool _isLoading = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Confirm your identity"),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Image.memory(
                      base64.decode(widget.userdata['image'][0]['imgpath']),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ClipRRect(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(8)),
                    child: _image != null
                        ? Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8)),
                                child: Image(
                                  fit: BoxFit.fitWidth,
                                  image: FileImage(_image),
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                              Icon(Icons.camera_alt, color: Colors.grey[800]),
                              Container(
                                height: 110,
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                    "กรุณาใช้ภาพใบหน้า \n เพื่อยืนยันตัวตน",
                                    textAlign: TextAlign.center),
                              )
                            ],
                          ))
              ],
            ),
            Column(
              children: <Widget>[
                TextField(
                  style: TextStyle(color: Color(0xFF000000)),
                  enabled: false,
                  cursorColor: Color(0xFF9b9b9b),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.event,
                      color: Colors.blueAccent,
                    ),
                    hintText: widget.data['event_name'],
                    hintStyle: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                TextField(
                  style: TextStyle(color: Color(0xFF000000)),
                  enabled: false,
                  cursorColor: Color(0xFF9b9b9b),
                  keyboardType: TextInputType.text,
                  // maxLines: 2,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.timelapse,
                      color: Colors.blueAccent,
                    ),
                    hintText: widget.data['duration'],
                    hintStyle: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                TextField(
                  style: TextStyle(color: Color(0xFF000000)),
                  enabled: false,
                  cursorColor: Color(0xFF9b9b9b),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.place,
                      color: Colors.blueAccent,
                    ),
                    hintText: widget.data['location'],
                    hintStyle: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                TextField(
                  style: TextStyle(color: Color(0xFF000000)),
                  enabled: false,
                  cursorColor: Color(0xFF9b9b9b),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.text_snippet_rounded,
                        color: Colors.blueAccent),
                    hintText: widget.data['detail'],
                    hintStyle: TextStyle(
                        // height: 3.5,
                        color: Colors.blueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        child: Text(
                          _isLoading ? 'Checking your identity...' : 'Confirm',
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
                          borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              // SharedPreferences localStorage = await SharedPreferences.getInstance();
                              // var userJson = localStorage.getString('user');
                              // var user = json.decode(userJson);

                              setState(() {
                                _isLoading = true;
                              });

                              String base64Image =
                                  base64Encode(_image.readAsBytesSync());

                              widget.data["imgpath"] = base64Image;

                              var res = await CallApi()
                                  .postData(widget.data, 'event/register/');
                              var body = jsonDecode(res.body);

                              print(body);

                              if (body['success']) {
                                var resHomepage = await CallApi()
                                    .getData('event/get_all_event/');
                                var bodyHomepage =
                                    json.decode(resHomepage.body);

                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            OrganizerPage(data: bodyHomepage)));
                              } else {
                                print(body);
                                final snackbar = SnackBar(
                                    content: Text(body['error'][0].toString()));

                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                  _isLoading = false;
                                });
                              }
                            }),
                ),
              ],
            ),
          ],
        )));
  }
}
