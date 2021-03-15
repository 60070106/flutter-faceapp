import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/home/home_page.dart';
import 'package:kmitl64app/pages/login/signin_field_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool _isLoading = false;
  File _image;
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

  void _takePicture(File _image) async {
    // final cameras = await availableCameras();
    // final frontCamera = cameras[1];

    String base64Image = base64Encode(_image.readAsBytesSync());

    setState(() {
      _isLoading = true;
    });

    var data = {
      'username': userNameController.text,
      'password': passwordController.text,
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'phone': phoneController.text,
      'image': [
        {'imgpath': base64Image}
      ]
    };

    var res = await CallApi().postData(data, 'register/');
    var body = await json.decode(res.body);

    var resHomepage = await CallApi().getData('event/get_all_event/');
    var bodyHomepage = json.decode(resHomepage.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));

      var userJson = localStorage.getString('user');
      var user = json.decode(userJson);

      var data = {"username": user['username']};

      var resDataAttendance =
          await CallApi().postData(data, 'event/camp/attendance/');
      var bodyDataAttendance = json.decode(resDataAttendance.body);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  data: bodyHomepage,
                  userdata: user,
                  eventAttendance: bodyDataAttendance,
                )
            // builder: (context) => TestMyApp(),
            ),
      );
    } else {
      var text = "";

      if (body['username'][0] != null) {
        text = body['username'][0];
      } else {
        text = body['detail'];
      }
      final snackbar = SnackBar(content: Text(text));

      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.4, 0.9],
                colors: [
                  Color(0xFFFF835F),
                  Color(0xFFFC663C),
                  Color(0xFFFF3F1A),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 60)),
                ClipOval(
                    child: _image != null
                        ? Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ClipOval(
                                child: Image(
                                  fit: BoxFit.fitWidth,
                                  image: FileImage(_image),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
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
                                width: MediaQuery.of(context).size.width * 0.6,
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
                                // color: Colors.teal,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: ClipOval(
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
                              ),
                              Icon(Icons.camera_alt, color: Colors.grey[800]),
                            ],
                          )),
                Padding(padding: EdgeInsets.only(bottom: 25)),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          elevation: 4.0,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: userNameController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                    ),
                                    hintText: "กรุณาใส่ username",
                                    hintStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                TextField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: passwordController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.grey,
                                    ),
                                    hintText: "กรุณาใส่รหัสผ่าน",
                                    hintStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                TextField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: firstNameController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.text_snippet_rounded,
                                      color: Colors.grey,
                                    ),
                                    hintText: "กรุณาใส่ชื่อจริง",
                                    hintStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                TextField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: lastNameController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.text_snippet_rounded,
                                      color: Colors.grey,
                                    ),
                                    hintText: "กรุณาใส่นามสกุล",
                                    hintStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                TextField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: phoneController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.contact_phone_rounded,
                                      color: Colors.grey,
                                    ),
                                    hintText: "กรุณาใส่เบอร์โทรศัพท์",
                                    hintStyle: TextStyle(
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
                                          _isLoading
                                              ? 'Creating...'
                                              : 'Create account',
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
                                      onPressed: _isLoading
                                          ? null
                                          : () async {
                                              _takePicture(_image);
                                            }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => LogInPage()));
                            },
                            child: Text(
                              'Already have an Account?',
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}