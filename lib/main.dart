import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linepay/InQueue.dart';
import 'package:linepay/LinePayColors.dart';
import 'package:linepay/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:linepay/authentication/firebase_options.dart';
import 'ApiCalling/Api.dart';
import 'LinePayTheme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinePay',
      theme: CustomTheme.lightTheme,
      home: NumericKeyboardPage(title: "Enter a line code"),
    );
  }
}

class NumericKeyboardPage extends StatefulWidget {
  NumericKeyboardPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NumericKeyboardState createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboardPage> {
  String text = '';
  Future<JoinLineResponse>? _futureJoinLineResponse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGround,
        title: Text(widget.title,
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 24,
            color: text_color,
          ),),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: (_futureJoinLineResponse == null) ? buildColumn() : buildFutureBuilder(),

      )
    );
  }

  Column buildColumn() {
    return Column(
      children: <Widget>[
      TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter a line code',
        ),
        onSubmitted: (value) {
          print('onSubmitted');
          setState(() {
            _futureJoinLineResponse = joinLine(value, "1");
          });
        },
      ),
      ]
    );
  }

  FutureBuilder<JoinLineResponse> buildFutureBuilder() {
    return FutureBuilder<JoinLineResponse>(
      future: _futureJoinLineResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  //todo: replace with real home page
                    builder: (context) => InQueuePage(lineID: snapshot.data!.lineID, userID: snapshot.data!.userID,)));
          });
        } else if (snapshot.hasError) {
          return Column(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a line code',
                  ),
                  onSubmitted: (value) {
                    print('onSubmitted');
                    setState(() {
                      _futureJoinLineResponse = joinLine(value, "1");
                    });
                  },
                ),
                Text('${snapshot.error}')
              ]
          );
        }
        return Center(
            child:CircularProgressIndicator()
        );
      },
    );
  }
}