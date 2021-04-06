import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/camper/home_page.dart';
import 'package:kmitl64app/pages/login/signin_field_page.dart';
import 'package:kmitl64app/pages/organizer/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  File _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

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
      'repassword': repasswordController.text,
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'image': [
        {'imgpath': base64Image}
      ]
    };

    var res = await CallApi().postData(data, 'register/');
    var body = await json.decode(res.body);

    if (body['success']) {
      var resLogin = await CallApi().postData({
        "username": userNameController.text,
        "password": passwordController.text
      }, 'login/');
      var bodyLogin = await json.decode(resLogin.body);

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', bodyLogin['token']);
      localStorage.setString('user', json.encode(bodyLogin['user']));

      var userJson = localStorage.getString('user');
      var user = json.decode(userJson);

      var data = {"username": user['username']};

      var resHomepage = await CallApi().getData('event/get_all_event/');
      var bodyHomepage = json.decode(resHomepage.body);

      var resDataAttendance =
          await CallApi().postData(data, 'event/camp/attendance/');
      var bodyDataAttendance = json.decode(resDataAttendance.body);

      localStorage.setString('data', json.encode(bodyHomepage));
      localStorage.setString('attendance', json.encode(bodyDataAttendance));

      if (bodyLogin['user']['is_camper']) {
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
      } else if (bodyLogin['user']['is_organizer']) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrganizerPage(data: bodyHomepage)));
      } else if (bodyLogin['user']['is_approver']) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => OrganizerPage(data: bodyHomepage)));
      }
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
                Form(
                  key: _formKey,
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
                                TextFormField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: firstNameController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.text_snippet_rounded,
                                      color: Colors.grey,
                                    ),
                                    labelText: "ชื่อ",
                                    labelStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z]'))
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกชื่อ';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: lastNameController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.text_snippet_rounded,
                                      color: Colors.grey,
                                    ),
                                    labelText: "นามสกุล",
                                    labelStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z]'))
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกนามสกุล';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: userNameController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                    ),
                                    labelText: "ชื่อผู้ใช้",
                                    labelStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกชื่อผู้ใช้';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: phoneController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.contact_phone_rounded,
                                      color: Colors.grey,
                                    ),
                                    labelText: "เบอร์โทรศัพท์",
                                    labelStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกเบอร์โทรศัพท์';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: emailController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอก Email';
                                    }
                                    if (!EmailValidator.validate(value)) {
                                      return 'Email ไม่ถูกต้อง';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
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
                                    labelText: "รหัสผ่าน",
                                    labelStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    Pattern pattern =
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                                    RegExp regex = new RegExp(pattern);
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกรหัสผ่าน';
                                    }
                                    if (!regex.hasMatch(value)) {
                                      return 'รหัสผ่านไม่ถูกต้อง';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  controller: repasswordController,
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.grey,
                                    ),
                                    labelText: "ยืนยันรหัสผ่าน",
                                    labelStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกยืนยันรหัสผ่าน';
                                    }
                                    if (value != passwordController.text) {
                                      return 'รหัสผ่านไม่ถูกต้อง';
                                    }
                                    return null;
                                  },
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
                                              if (_formKey.currentState
                                                  .validate()) {}
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
