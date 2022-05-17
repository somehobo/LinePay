import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiCalling/ResponseObjects.dart';
import '../preferences/LinePayColors.dart';

// LOGIN PAGE CLASS
class PayPage extends StatefulWidget {
  const PayPage(
      {Key? key,
      required this.linePos,
      required this.lineID,
      required this.userID})
      : super(key: key);
  final int lineID;
  final String userID;
  final String linePos;

  @override
  State<PayPage> createState() => _PayPageState();
}

// LOGIN PAGE SCAFFOLD
class _PayPageState extends State<PayPage> {
  String userID = "";
  var userPos = -1;
  var nextInLine = false;
  var _clockTimer;

  setUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID')!;
  }

  @override
  void initState() {
    setUserID();
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      LineDataResponse _lineDataResponse =
          await getLineData(widget.lineID.toString(), widget.userID);
      var newPosition = _lineDataResponse.position;
      if (newPosition != userPos) {
        setState(() {
          userPos = newPosition;
        });
      }
      setState(() {
        nextInLine = (userPos == 0);
        if (nextInLine) {
          _clockTimer.cancel();
          nextInLineBox(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(color: text_color),
          backgroundColor: backGround,
          title: Text(
            "Make offer to position " + widget.linePos,
            textAlign: TextAlign.center,
            style: TextStyle(color: text_color),
          ),
          centerTitle: true),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Amount',
              hintStyle: const TextStyle(color: Colors.white),
              fillColor: Theme.of(context).primaryColor,
              filled: true,
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            onSubmitted: (value) async {
              print(widget.linePos);
              var _createdOfferResponse =
                  await CreateOffer(userID, widget.linePos, value);
              if (_createdOfferResponse.accepted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
