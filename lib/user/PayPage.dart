import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linepay/authentication/signup.dart';
import 'package:linepay/main.dart';
import 'package:camera/camera.dart';


// LOGIN PAGE CLASS
class PayPage extends StatefulWidget {
  const PayPage({Key? key, required this.linePos}) : super(key: key);

  final String linePos;

  @override
  State<PayPage> createState() => _PayPageState();
}

// LOGIN PAGE SCAFFOLD
class _PayPageState extends State<PayPage> {
  var buyNow = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.linePos),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(width: 0.0, color: Colors.black),
            ),
            child: Center(
              child: Text("Buy :", style: TextStyle(fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }
}