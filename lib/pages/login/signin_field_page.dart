import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/approver/documentcheck_page.dart';
import 'package:kmitl64app/pages/camper/home_page.dart';
import 'package:kmitl64app/pages/organizer/home.dart';
import 'package:kmitl64app/pages/register/signup_field_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ScaffoldState scaffoldState;
  _showMsg(msg) {
    print(msg);

    _scaffoldKey.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));

    _isLoading = false;
    print(_isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          children: <Widget>[
            ///////////  background///////////
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              /////////////  Email//////////////
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                controller: usernameController,
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

                              /////////////// password////////////////////
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                controller: passwordController,
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกรหัสผ่าน';
                                  }
                                  return null;
                                },
                              ),
                              /////////////  LogIn Botton///////////////////
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
                                        _isLoading ? 'Loging...' : 'Login',
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    color: Color(0xFFFF835F),
                                    disabledColor: Colors.grey,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0)),
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            if (_formKey.currentState
                                                .validate()) {
                                              _login();
                                            } else {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ////////////   new account///////////////
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          'Create new Account',
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
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'username': usernameController.text,
      'password': passwordController.text
    };

    var res = await CallApi().postData(data, 'login/');
    var body = jsonDecode(res.body);

    // var resHomepage = await CallApi().getData('event/get_all_event/');
    // var bodyHomepage = json.decode(resHomepage.body);

    // print(bodyHomepage[0]);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));

      var userJson = localStorage.getString('user');

      if (body['user']['is_camper']) {
        var user = json.decode(userJson);
        var data = {"username": user['username']};

        var resDataAttendance =
            await CallApi().postData(data, 'event_camp_attendance/');
        var bodyDataAttendance = json.decode(resDataAttendance.body);

        var resHomepage = await CallApi().getData('get_all_event/');
        var bodyHomepage = json.decode(resHomepage.body);

        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => HomePage(
                      userdata: user,
                      data: bodyHomepage,
                      eventAttendance: bodyDataAttendance,
                    )));
      }
      if (body['user']['is_organizer']) {
        // ignore: non_constant_identifier_names
        var res_organizer = await CallApi().getData('get_all_event/');
        // ignore: non_constant_identifier_names
        var body_organizer = json.decode(res_organizer.body);

        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => OrganizerPage(data: body_organizer)));
      }
      if (body['user']['is_approver']) {
        var res_approver = await CallApi().getData('get_all_event/');
        var body_approver = json.decode(res_approver.body);

        var userApprover = json.decode(userJson);

        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => DocumentCheckPage(
                    data: body_approver, user: userApprover)));
      }
    } else if (body['success'] = false) {
      _showMsg(body['detail']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
