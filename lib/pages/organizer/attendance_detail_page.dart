import 'dart:convert';
import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceDetailPage extends StatefulWidget {
  var data;
  AttendanceDetailPage({this.data});
  @override
  _AttendanceDetailPageState createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  int _Page = 0;

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Check in',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.people,
        data: List.generate(
            widget.data['checkInPerday']['date'].length,
            (index) => TimeSeriesSales(
                DateTime(
                    int.parse(widget.data['checkInPerday']['date'][index]
                        .toString()
                        .substring(0, 4)),
                    int.parse(widget.data['checkInPerday']['date'][index]
                        .toString()
                        .substring(5, 7)),
                    int.parse(widget.data['checkInPerday']['date'][index]
                        .toString()
                        .substring(8, 10))),
                widget.data['checkInPerday']['people'][index])),
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Check out',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.people,
        data: List.generate(
            widget.data['checkOutPerday']['date'].length,
            (index) => TimeSeriesSales(
                DateTime(
                    int.parse(widget.data['checkOutPerday']['date'][index]
                        .toString()
                        .substring(0, 4)),
                    int.parse(widget.data['checkOutPerday']['date'][index]
                        .toString()
                        .substring(5, 7)),
                    int.parse(widget.data['checkOutPerday']['date'][index]
                        .toString()
                        .substring(8, 10))),
                widget.data['checkOutPerday']['people'][index])),
      )
    ];
  }

  Widget dataAttendance() {
    print(int.parse(
        widget.data['checkInPerday']['date'][0].toString().substring(0, 4)));
    print(int.parse(
        widget.data['checkInPerday']['date'][0].toString().substring(5, 7)));
    print(int.parse(
        widget.data['checkInPerday']['date'][0].toString().substring(8, 10)));
    return (_Page == 0)
        ? Expanded(
            child: widget.data['checkInData'] != null
                ? widget.data['checkInData'].length != 0
                    ? CustomScrollView(primary: false, slivers: <Widget>[
                        SliverList(
                            delegate: SliverChildListDelegate(
                                List<Widget>.generate(
                                    widget.data['checkInData'].length, (index) {
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
                                        SizedBox(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                // color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4885,
                                                height: 130,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
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
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text("Check in",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          "ชื่อ-นามสกุล: " +
                                                              widget.data['checkInData']
                                                                          [
                                                                          index]
                                                                      ['user'][
                                                                  'first_name'] +
                                                              ' ' +
                                                              widget.data['checkInData']
                                                                          [index]
                                                                      ['user']
                                                                  ['last_name'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          "เบอร์: " +
                                                              widget.data['checkInData']
                                                                          [
                                                                          index]
                                                                      ['user']
                                                                  ['phone'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          "อีเมลล์: " +
                                                              widget.data['checkInData']
                                                                          [
                                                                          index]
                                                                      ['user']
                                                                  ['email'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0),
                                                      child: Text(
                                                        DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.data['checkInData'][index]['time'].substring(0, 10) + " " + widget.data['checkInData'][index]['time'].substring(11, 19), true).toLocal().toString().substring(
                                                                8, 10) +
                                                            "/" +
                                                            DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.data['checkInData'][index]['time'].substring(0, 10) + " " + widget.data['checkInData'][index]['time'].substring(11, 19), true).toLocal().toString().substring(
                                                                5, 7) +
                                                            "/" +
                                                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                                                .parse(
                                                                    widget.data['checkInData'][index]['time'].substring(0, 10) +
                                                                        " " +
                                                                        widget.data['checkInData'][index]['time'].substring(
                                                                            11, 19),
                                                                    true)
                                                                .toLocal()
                                                                .toString()
                                                                .substring(
                                                                    0, 4) +
                                                            "  +" +
                                                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                                                .parse(
                                                                    widget.data['checkInData'][index]['time'].substring(0, 10) +
                                                                        " " +
                                                                        widget.data['checkInData'][index]['time'].substring(11, 19),
                                                                    true)
                                                                .toLocal()
                                                                .toString()
                                                                .substring(11, 19),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4003,
                                                  height: 180,
                                                  child: Image.memory(
                                                    base64.decode(widget.data[
                                                                'checkInData']
                                                            [index]['user']
                                                        ['image']),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ]))
                            ],
                          ));
                        })))
                      ])
                    : Text(
                        "no one check in in this event yet.",
                        style: TextStyle(color: Colors.black38),
                      )
                : Center(child: CircularProgressIndicator()))
        : _Page == 1
            ? widget.data['checkOutData'] != null
                ? widget.data['checkOutData'].length != 0
                    ? Expanded(
                        child:
                            CustomScrollView(primary: false, slivers: <Widget>[
                          SliverList(
                              delegate: SliverChildListDelegate(
                                  List<Widget>.generate(
                                      widget.data['checkOutData'].length,
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
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                // color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4885,
                                                height: 130,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
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
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text("Check out",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          "ชื่อ-นามสกุล: " +
                                                              widget.data['checkOutData']
                                                                          [
                                                                          index]
                                                                      ['user'][
                                                                  'first_name'] +
                                                              ' ' +
                                                              widget.data['checkOutData']
                                                                          [index]
                                                                      ['user']
                                                                  ['last_name'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          "เบอร์: " +
                                                              widget.data['checkOutData']
                                                                          [
                                                                          index]
                                                                      ['user']
                                                                  ['phone'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: Text(
                                                          "อีเมลล์: " +
                                                              widget.data['checkOutData']
                                                                          [
                                                                          index]
                                                                      ['user']
                                                                  ['email'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0),
                                                      child: Text(
                                                        DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.data['checkOutData'][index]['time'].substring(0, 10) + " " + widget.data['checkOutData'][index]['time'].substring(11, 19), true).toLocal().toString().substring(
                                                                8, 10) +
                                                            "/" +
                                                            DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.data['checkOutData'][index]['time'].substring(0, 10) + " " + widget.data['checkOutData'][index]['time'].substring(11, 19), true).toLocal().toString().substring(
                                                                5, 7) +
                                                            "/" +
                                                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                                                .parse(
                                                                    widget.data['checkOutData'][index]['time'].substring(0, 10) +
                                                                        " " +
                                                                        widget.data['checkOutData'][index]['time'].substring(
                                                                            11, 19),
                                                                    true)
                                                                .toLocal()
                                                                .toString()
                                                                .substring(
                                                                    0, 4) +
                                                            "  +" +
                                                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                                                .parse(
                                                                    widget.data['checkOutData'][index]['time'].substring(0, 10) +
                                                                        " " +
                                                                        widget.data['checkOutData'][index]['time'].substring(11, 19),
                                                                    true)
                                                                .toLocal()
                                                                .toString()
                                                                .substring(11, 19),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue),
                                                        //  widget.data['checkInData'][index]['time']
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4003,
                                                  height: 180,
                                                  child: Image.memory(
                                                    base64.decode(widget.data[
                                                                'checkOutData']
                                                            [index]['user']
                                                        ['image']),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ]))
                              ],
                            ));
                          })))
                        ]),
                      )
                    : Text(
                        "no one check out in this event yet.",
                        style: TextStyle(color: Colors.black38),
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
                  title: Text("Event detail"),
                  bottom:
                      TabBar(indicatorColor: Colors.amberAccent, tabs: <Tab>[
                    Tab(text: "Attandance Detail", icon: Icon(Icons.event)),
                    Tab(text: "Statistic", icon: Icon(Icons.stacked_bar_chart))
                  ])),
              body: TabBarView(children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _Page = 0;
                                      });
                                    },
                                    child: Text("Check in")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _Page = 1;
                                      });
                                    },
                                    child: Text("Check out")),
                              )
                            ],
                          ),
                        ),
                      ),
                      dataAttendance()
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Card(
                              child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("ภาพรวมการเข้าร่วมกิจกรรม",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17))),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: charts.TimeSeriesChart(
                                  _createSampleData(),
                                  animate: true,
                                  defaultRenderer:
                                      new charts.LineRendererConfig(),
                                  customSeriesRenderers: [
                                    new charts.PointRendererConfig()
                                  ],
                                  dateTimeFactory:
                                      const charts.LocalDateTimeFactory(),
                                  behaviors: [
                                    charts.SeriesLegend(showMeasures: true)
                                  ],
                                ),
                              )
                            ],
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: Text(
                            "รายชื่อผู้เข้าร่วม",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Column(
                            children: List.generate(
                                widget.data['registerPeople'].length, (index) {
                          return Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 17, top: 15),
                                child: Text(
                                  widget.data['registerPeople'][index]
                                          ['first_name'] +
                                      "  " +
                                      widget.data['registerPeople'][index]
                                          ['last_name'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Text(
                                  widget.data['registerPeople'][index]['phone'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              )
                            ],
                          );
                        })),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: Text(
                            "ความนิยมของกิจกรรม",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Stack(children: [
                                  charts.PieChart([
                                    new charts.Series<AmountPeopleSeries, int>(
                                        id: 'Sales',
                                        domainFn:
                                            (AmountPeopleSeries sales, _) =>
                                                sales.part,
                                        measureFn:
                                            (AmountPeopleSeries sales, _) =>
                                                sales.people,
                                        labelAccessorFn:
                                            (AmountPeopleSeries sales, _) =>
                                                '${sales.people}',
                                        data: [
                                          AmountPeopleSeries(
                                              0,
                                              widget.data['registerPeople']
                                                  .length),
                                          AmountPeopleSeries(
                                              1,
                                              widget.data['allPeopleSystem'] -
                                                  widget.data['registerPeople']
                                                      .length)
                                        ])
                                  ],
                                      defaultRenderer: charts.ArcRendererConfig(
                                        arcWidth: 25,
                                      )),
                                  Center(
                                    child: Text(
                                      ((widget.data['registerPeople'].length /
                                                      widget.data[
                                                          'allPeopleSystem']) *
                                                  100)
                                              .toStringAsFixed(0) +
                                          "%",
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ])),
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "คนที่สมัครกิจกรรมนี้ต่อคนทั้งระบบ : " +
                                              widget
                                                  .data['registerPeople'].length
                                                  .toString() +
                                              "/" +
                                              widget.data['allPeopleSystem']
                                                  .toString()),
                                      Text("ยอดเช็คอินทั้งหมด : " +
                                          widget.data['checkInCount']
                                              .toString()),
                                      Text("ยอดเช็คเอ้าท์ทั้งหมด : " +
                                          widget.data['checkOutCount']
                                              .toString()),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
              ]),
            )));
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int people;
  TimeSeriesSales(this.time, this.people);
}

class AmountPeopleSeries {
  final int part;
  final int people;
  AmountPeopleSeries(this.part, this.people);
}
