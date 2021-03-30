import 'package:flutter/material.dart';
import 'package:kmitl64app/pages/approver/documentcheck_page.dart';

class ApproverHomePage extends StatefulWidget {
  var data;
  ApproverHomePage({this.data});

  @override
  _ApproverHomePageState createState() => _ApproverHomePageState();
}

class _ApproverHomePageState extends State<ApproverHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose your role")),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        // color: Colors.amberAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DocumentCheckPage(data: widget.data)),
                              );
                    }, child: Text("ตรวจสอบเอกสาร")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {}, child: Text("นายกสโมสรนักศึกษา")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {}, child: Text("ที่ปรึกษาสโมสรนักศึกษา")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: () {}, child: Text("ที่ปรึกษาโครงการ")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
