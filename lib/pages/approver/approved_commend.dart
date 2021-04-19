import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmitl64app/api.dart';
import 'package:kmitl64app/pages/approver/documentcheck_page.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommendApprovedPage extends StatefulWidget {
  var data;
  CommendApprovedPage({this.data});

  @override
  _CommendApprovedPageState createState() => _CommendApprovedPageState();
}

class _CommendApprovedPageState extends State<CommendApprovedPage> {
  bool documentApproved = false;
  bool documentUnapproved = false;
  bool _isLoading = false;

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Detail")),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "เอกสารที่เกี่ยวข้อง",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              widget.data['documents'].length == 0
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "ไม่พบเอกสารที่อัพโหลด",
                        style: TextStyle(color: Colors.black38, fontSize: 10),
                      ),
                    )
                  : Column(
                      children: List<Widget>.generate(
                          widget.data['documents'].length, (index) {
                        return Center(
                            child: PdfDocumentLoader.openData(
                          base64
                              .decode(widget.data['documents'][index]['data']),
                          documentBuilder: (context, pdfDocument, pageCount) =>
                              LayoutBuilder(
                                  builder: (context, constraints) => Container(
                                        // color: Colors.amberAccent,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: pageCount,
                                            itemBuilder: (context, index) =>
                                                Container(
                                                    // margin:
                                                    //     EdgeInsets.all(8),
                                                    padding: EdgeInsets.all(8),
                                                    color: Colors.black12,
                                                    child: PdfPageView(
                                                      pdfDocument: pdfDocument,
                                                      pageNumber: index + 1,
                                                    ))),
                                      )),
                        ));
                      }),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // [Monday] checkbox
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("ผ่าน"),
                      Checkbox(
                        value: documentApproved,
                        checkColor: Colors.yellow,
                        activeColor: Colors.lightGreen,
                        onChanged: (bool value) {
                          setState(() {
                            documentApproved = value;
                            documentUnapproved = false;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("ไม่ผ่าน"),
                      Checkbox(
                        value: documentUnapproved,
                        checkColor: Colors.yellow,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          setState(() {
                            documentApproved = false;
                            documentUnapproved = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              documentUnapproved
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        style: TextStyle(color: Color(0xFF000000)),
                        controller: commentController,
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
                    )
                  : Container(),
              Center(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: FlatButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  var userJson = localStorage.getString('user');
                                  var user = json.decode(userJson);

                                  var eventCommentData = {
                                    'agreed': documentApproved,
                                    'detail': commentController.text != "" 
                                      ? commentController.text 
                                      : "ผ่าน",
                                    'event_name': widget.data['event_name'],
                                    'approver': user['username'],
                                  };

                                  print(eventCommentData);

                                  var res = await CallApi().postData(
                                      eventCommentData,
                                      'event_approver_check/');
                                  var body = jsonDecode(res.body);

                                  print(body);

                                  if (body['success']) {
                                    var resHomepage = await CallApi()
                                        .getData('get_all_event/');
                                    var bodyHomepage =
                                        json.decode(resHomepage.body);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DocumentCheckPage(
                                                  data: bodyHomepage)),
                                    );
                                  }
                                },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 8, bottom: 8, left: 10, right: 10),
                            child: Text(
                              _isLoading
                                  ? 'กำลังส่งข้อมูล...'
                                  : 'ยืนยันการตรวจสอบรายละเอียดเอกสาร',
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
                              borderRadius: new BorderRadius.circular(20.0)))))
            ],
          ),
        ),
      ),
    );
  }
}
