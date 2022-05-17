import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linepay/preferences/LinePayColors.dart';
import 'package:linepay/user/PayPage.dart';
import 'package:linepay/main.dart';
import 'package:tuple/tuple.dart';
import 'package:linepay/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:linepay/authentication/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:linepay/ApiCalling/ResponseObjects.dart';
import 'package:collection/collection.dart';
import 'package:linepay/user/Offers.dart';

class Tair<T1, T2, T3> {
  final T1 a;
  final T2 b;
  final T3 index;

  Tair(this.a, this.b, this.index);
}

class InQueuePage extends StatefulWidget {
  const InQueuePage({Key? key, required this.userID, required this.lineID})
      : super(key: key);

  final int lineID;
  final String userID;

  @override
  _InQueuePageState createState() => _InQueuePageState();
}

class _InQueuePageState extends State<InQueuePage> {
  var lineCode = "";
  var lineName = "";
  var position = 0;
  var estWaitTime = 23;
  var number = 22;
  var offers = 0;
  var forSale = false;
  var _clockTimer;
  //will depend of whether or not line is listed in backend
  var listedPos = false;
  var lineSales = [
    Tair(0, 0, 0),
  ];

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      LineDataResponse _lineDataResponse =
          await getLineData(widget.lineID.toString(), widget.userID);
      var newLineName = _lineDataResponse.lineName;
      if (newLineName != lineName) {
        setState(() {
          lineName = _lineDataResponse.lineName;
        });
      }
      var newPosition = _lineDataResponse.position;
      if (newPosition != position) {
        setState(() {
          position = newPosition;
        });
      }
      var newOffers = _lineDataResponse.offersToMe;
      if (newOffers != offers) {
        setState(() {
          offers = newOffers;
        });
      }
      var newForsale = _lineDataResponse.positionForSale;
      if (forSale != newForsale) {
        setState(() {
          forSale = newForsale;
        });
      }
      var newPositionsForSale = _lineDataResponse.positionsForSale;
      newPositionsForSale.sort();
      var newPositionsForSaleLength = newPositionsForSale.length;
      var newlineSales = [Tair(0, 0, 0)];
      for (var i = 0; i < newPositionsForSaleLength; i++) {
        newlineSales.add(Tair(newPositionsForSale[i], 00, i + 1));
      }
      Function eq = const ListEquality().equals;
      if (!eq(newlineSales, lineSales)) {
        setState(() {
          lineSales = newlineSales;
        });
      }
      var newLineCode = _lineDataResponse.lineCode;
      if (newLineCode != lineCode) {
        setState(() {
          lineCode = newLineCode;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backGround,
          leading: TextButton(
              child: const Text(
                "Leave",
                style: TextStyle(color: text_color),
              ),
              onPressed: () => {
                leaveLine(widget.userID),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NumericKeyboardPage()),
                    (route) => false)
              }),
          title: Text(
            'In Line for: ' + lineName,
            style: const TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: text_color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(width: 0.0, color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        "Line Code: " + lineCode,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 0.0, color: Colors.black),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              child: Text(
                                (position >= 0)
                                    ? "Position: " + position.toString()
                                    : 'Position: ',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            sellPosition()
                          ],
                        ),
                      )),
                  // const Padding(padding: EdgeInsets.only(top: 10)),
                  // Text(
                  //   "Estimated wait time: " + estWaitTime.toString() + " min",
                  //   style: const TextStyle(fontSize: 20),
                  //   textAlign: TextAlign.left,
                  // ),
                ],
              ),
              bottomLinesSheet()
            ],
          ),
        ));
  }

  Widget bottomLinesSheet() {
    return DraggableScrollableSheet(
      initialChildSize: .4,
      minChildSize: .1,
      maxChildSize: .6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).dialogBackgroundColor,
            ),
            child: ListView(
                controller: scrollController,
                children: lineSales
                    .map<Widget>((linePos) => lineListing(linePos))
                    .toList()));
      },
    );
  }

  FloatingActionButton sellPosition() {
    if (forSale) {
      return FloatingActionButton.extended(
        onPressed: () => navigateToOffers(),
        label: Text(
          "Offers: " + offers.toString(),
          style: const TextStyle(color: Colors.black),
        ),
      );
    }
    return FloatingActionButton.extended(
      onPressed: () => toggleSale(widget.userID),
      label: const Text(
        "List Position",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  navigateToOffers() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OffersPage(userID: widget.userID, lineID: widget.lineID)),
    );
  }

  linePattern(int index) {
    if (index.isEven) {
      return Theme.of(context).primaryColor;
    }
    return Theme.of(context).colorScheme.secondary;
  }

  lineListing(Tair linePos) {
    if (linePos.index == 0) {
      //return title widget
      return Container(
        child: Text(
          "Positions For Sale",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        padding: EdgeInsets.only(top: 10),
      );
    }
    return Container(
        padding: EdgeInsets.only(top: 10, left: 7, right: 7),
        child: Container(
          height: 45,
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: linePattern(linePos.index),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: InkWell(
            child: Align(
              child: Text(
                "       Line Position: "+ linePos.a.toString(),
                style: const TextStyle(fontSize: 20),
              ),
              alignment: Alignment.centerLeft,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PayPage(linePos: linePos.a.toString())),
              );
            },
          ),
        ));
  }
}
