import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:linepay/preferences/LinePayColors.dart';

// LINE DETAILS CLASS
class LineDetails extends StatefulWidget {
  const LineDetails({Key? key}) : super(key: key);

  @override
  State<LineDetails> createState() => _LineDetailsState();
}

class _LineDetailsState extends State<LineDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: text_color),
        backgroundColor: backGround,
        title: const Text(
          'linename',
          style: TextStyle(
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
                // todo: GET NUMBER OF PERSONS IN LINE
                Text('120',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 70)),
              ],
            ),
          ),
          // todo: streambuilder for line count goes here
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
                                  onTap: null,
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
