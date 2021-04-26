import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/camper/home_page.dart';

class CheckinIdentityPage extends StatefulWidget {
  var data;
  var userdata;

  CheckinIdentityPage({this.data, this.userdata});
  @override
  _CheckinIdentityPageState createState() => _CheckinIdentityPageState();
}

class _CheckinIdentityPageState extends State<CheckinIdentityPage> {
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
                      base64.decode(widget.userdata['image']),
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
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
                              .postData(widget.data, 'event_camp_check/');
                          var body = jsonDecode(res.body);

                          if (body['success']) {
                            print(body);
                            var resHomepage =
                                await CallApi().getData('get_all_event/');
                            var bodyHomepage = json.decode(resHomepage.body);

                            var resDataAttendance = await CallApi().postData(
                                {"username": widget.userdata['username']},
                                'event_camp_attendance/');
                            var bodyDataAttendance =
                                json.decode(resDataAttendance.body);

                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          data: bodyHomepage,
                                          userdata: widget.userdata,
                                          eventAttendance: bodyDataAttendance,
                                        )));
                          } else {
                            print(body['detail'][0]);
                            final snackbar =
                                SnackBar(content: Text(body['detail'][0]));

                            setState(() {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              _isLoading = false;
                            });
                          }
                        }),
            ),
          ],
        )));
  }
}
