import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linepay/user/DefaultUser.dart';
import 'package:linepay/user/InQueue.dart';
import 'package:linepay/preferences/LinePayColors.dart';
import 'package:linepay/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:linepay/authentication/firebase_options.dart';
import 'ApiCalling/Api.dart';
import 'ApiCalling/ResponseObjects.dart';
import 'preferences/LinePayTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinePay',
      theme: CustomTheme.lightTheme,
      home: const NumericKeyboardPage(),
    );
  }
}

class NumericKeyboardPage extends StatefulWidget {
  const NumericKeyboardPage({Key? key}) : super(key: key);

  @override
  _NumericKeyboardState createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboardPage> {
  String text = '';
  Future<JoinLineResponse>? _futureJoinLineResponse;
  var authenticatedUser = "";

  addStringToSF(String userID) async {
    print(userID);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', userID);
  }

  isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('authenticated') != null) {
      if (prefs.getBool('authenticated') == true) {
        authenticatedUser = prefs.getString('userID')!;
      }
    }
  }

  @override
  void initState() {
    isAuthenticated();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: (_futureJoinLineResponse == null)
          ? buildColumn()
          : buildFutureBuilder(),
    ));
  }

  Column buildColumn() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                  flex: 3,
                  child: Text(
                    'LinePay',
                    style: TextStyle(fontSize: 48, color: text_color),
                  ),
                ),
                const SizedBox(height: 150),
                // const Spacer(),
                Flexible(
                  flex: 2,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter a line code',
                      hintStyle: const TextStyle(color: Colors.white),
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) {
                      if (authenticatedUser != null) {
                        setState(() {
                          _futureJoinLineResponse =
                              joinLineAuthenticated(value, authenticatedUser);
                        });
                      } else {
                        setState(() {
                          _futureJoinLineResponse = joinLine(value);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text('Are you a business?',
                              style:
                                  TextStyle(fontSize: 28, color: text_color)),
                          Text('Tap here to host!',
                              style: TextStyle(fontSize: 28, color: text_color))
                        ],
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginPage(isBusiness: true)))),
                )),
          ),
          const SizedBox(height: 50)
        ]);
  }

  FutureBuilder<JoinLineResponse> buildFutureBuilder() {
    return FutureBuilder<JoinLineResponse>(
      future: _futureJoinLineResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(authenticatedUser);
          if (authenticatedUser != "") {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      //todo: replace with real home page
                      builder: (context) => InQueuePage(
                            lineID: snapshot.data!.lineID,
                            userID: snapshot.data!.userID,
                          )));
            });
          } else {
            addStringToSF(snapshot.data!.userID);
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      //todo: replace with real home page
                      builder: (context) => DefaultUser(
                            lineID: snapshot.data!.lineID,
                            userID: snapshot.data!.userID,
                          )));
            });
          }
        } else if (snapshot.hasError) {
          return buildColumn();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
