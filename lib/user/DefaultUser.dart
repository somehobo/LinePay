import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:linepay/authentication/login.dart';
import 'package:linepay/preferences/LinePayColors.dart';

// DEFAULT USER CLASS
class DefaultUser extends StatefulWidget {
  const DefaultUser({Key? key, required this.lineInfo}) : super(key: key);
  final Future<JoinLineResponse>? lineInfo;

  @override
  State<DefaultUser> createState() => _DefaultUserState();
}

class _DefaultUserState extends State<DefaultUser> {
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
                    children: const [
                      Flexible(
                          flex: 1,
                          child: Text('In line for:',
                              style: TextStyle(
                                fontSize: 30,
                                color: text_color,
                              ))),
                      Flexible(
                          flex: 1,
                          // todo: business/line name goes here
                          child: Text('Business',
                              style:
                                  TextStyle(fontSize: 38, color: text_color))),
                      Spacer(),
                      // todo: user position
                      Flexible(
                          flex: 4,
                          child: Text(
                            '120',
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
                        onTap: () => null,
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
