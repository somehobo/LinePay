import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:linepay/ApiCalling/ResponseObjects.dart';
import 'package:linepay/authentication/login.dart';
import 'package:linepay/preferences/LinePayColors.dart';

import '../main.dart';

// DEFAULT USER CLASS
class DefaultUser extends StatefulWidget {
  const DefaultUser({Key? key,  required this.userID, required this.lineID}) : super(key: key);
  final int lineID;
  final String userID;
  @override
  State<DefaultUser> createState() => _DefaultUserState();
}

class _DefaultUserState extends State<DefaultUser> {
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


  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      print(timer.tick);
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
        body: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 4,
              child: Container(
                // padding: EdgeInsets.only(top: 80),
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Flexible(
                          flex: 1,
                          child: Text('In line for:',
                              style: TextStyle(
                                fontSize: 30,
                                color: text_color,
                              ))),
                      Flexible(
                          flex: 1,
                          child: Text(lineName,
                              style:
                                  TextStyle(fontSize: 38, color: text_color))),
                      Spacer(),
                      Flexible(
                          flex: 4,
                          child: Text(
                            "Position: " + position.toString(),
                            style: TextStyle(fontSize: 68, color: text_color),
                          ))
                    ]),
              )),
          Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    height: 50,
                    width: 370,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: InkWell(
                        // todo: pop to main
                        onTap: () => {
                          leaveLine(widget.userID),
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NumericKeyboardPage()),
                                  (route) => false)},
                        child: const Align(
                          child: Text('Leave',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white)),
                          alignment: Alignment.center,
                        ))),
              )),
          Flexible(
              flex: 1,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: InkWell(
                        child: const Text('Sign in to trade positions',
                            style: TextStyle(fontSize: 22, color: text_color)),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                // todo: get InQueue page data
                                builder: (context) => const LoginPage(
                                      isBusiness: false,
                                    )))),
                  ))),
        ],
      ),
    ));
  }
}
