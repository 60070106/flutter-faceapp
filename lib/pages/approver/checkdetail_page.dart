import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kmitl64app/pages/approver/approved_commend.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class CheckDocumentDetailPage extends StatefulWidget {
  var data;
  CheckDocumentDetailPage({this.data});

  @override
  _CheckDocumentDetailPageState createState() =>
      _CheckDocumentDetailPageState();
}

class _CheckDocumentDetailPageState extends State<CheckDocumentDetailPage> {
  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดกิจกรรม"),
        backgroundColor: Color(0xFF876aa4),
      ),
      body: Container(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Center(
            child: Image.memory(
              base64.decode(widget.data['event_image']),
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              // height: MediaQuery.of(context).size.height * 0.115,
              // color: Colors.grey,
              child: Center(
                child: Text(
                  widget.data['event_name'],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              )),
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              // color: Colors.grey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "วันที่จัดกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.data['duration'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      "สถานที่จัดกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.data['location'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      "รายละเอียดกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.data['detail'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      "รายละเอียดผู้จัดกิจกรรม",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.data['organizer']['first_name'] +
                            " " +
                            widget.data['organizer']['last_name'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.data['organizer']['phone'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        widget.data['organizer']['email'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20)),
                    Text(
                      "เอกสารที่เกี่ยวข้อง",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    widget.data['documents'].length == 0
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              "ไม่พบเอกสารที่อัพโหลด",
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 10),
                            ),
                          )
                        : Column(
                            children: List<Widget>.generate(
                                widget.data['documents'].length, (index) {
                              return Center(
                                  child: PdfDocumentLoader.openData(
                                base64.decode(
                                    widget.data['documents'][index]['data']),
                                documentBuilder: (context, pdfDocument,
                                        pageCount) =>
                                    LayoutBuilder(
                                        builder: (context, constraints) =>
                                            Container(
                                              // color: Colors.amberAccent,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.56,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: pageCount,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      Container(
                                                          // margin:
                                                          //     EdgeInsets.all(8),
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          color: Colors.black12,
                                                          child: PdfPageView(
                                                            pdfDocument:
                                                                pdfDocument,
                                                            pageNumber:
                                                                index + 1,
                                                          ))),
                                            )),
                              ));
                            }),
                          ),
                    widget.data['is_approved']
                    ? Center(
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: FlatButton(
                              onPressed:  _isButtonDisabled ? null : null,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                child: Text(
                                  'ได้รับการอนุมัติแล้ว',
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
                              disabledColor: Colors.lightGreen,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0)))),
                    )
                    : Center(
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommendApprovedPage(data: widget.data)),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                child: Text(
                                  'ดำเนินการต่อ',
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
                    )
                  ]))
        ],
      ))),
    );
  }
}
