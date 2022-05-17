import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linepay/preferences/LinePayColors.dart';

// LINE DETAILS CLASS
class LineDetails extends StatefulWidget {
  const LineDetails(
      {Key? key,
      required this.lineName,
      required this.persons,
      required this.lineID})
      : super(key: key);
  final String lineName;
  final int persons;
  final int lineID;

  @override
  State<LineDetails> createState() => _LineDetailsState();
}

class _LineDetailsState extends State<LineDetails> {
  late final SharedPreferences _prefs;
  late final String _boID;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<void> getSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _boID = _prefs.getString('boID').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: text_color),
        backgroundColor: backGround,
        title: Text(
          widget.lineName,
          style: const TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 24,
            color: text_color,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Persons in Line:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24)),
                const SizedBox(height: 30),
                Text(widget.persons.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 70)),
              ],
            ),
          ),
          Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 70,
                              width: 120,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                  // todo: CLOSE LINE FUNCTION
                                  onTap: null,
                                  child: Align(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Text('Close',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                        Text('Line',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                  ))),
                          Container(
                              height: 70,
                              width: 120,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                  // todo: DEQUEUE FUNCTION
                                  onTap: () {Dequeue(widget.lineID.toString(), "1");},
                                  child: Align(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Text('Next',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                        Text('Person',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                  ))),
                        ])),
              )),
          const SizedBox(height: 60)
        ],
      ),
    );
  }
}
