import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:linepay/business/LineDetails.dart';
import 'package:linepay/preferences/LinePayColors.dart';

// HOST PAGE CLASS
class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  late Stream<LineDataResponse> _hostData;
  // todo: get hosting data from api
  bool _hosting = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_hosting) ? hosting() : createLine();
  }

  Scaffold hosting() {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: text_color),
          backgroundColor: backGround,
          title: const Text(
            'Your Lines',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 24,
              color: text_color,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                SingleChildScrollView(
                    child: StreamBuilder(
                        stream: null, //_hostData,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Uh-oh, Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasData) {
                            LineDataResponse offerData = snapshot.data;
                            return ListView.separated(
                              itemCount: offerData.offersToMe,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                // todo: card builder
                                return Text('');
                              },
                            );
                          }
                          return const Text('No lines to show',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 20,
                                color: text_color,
                              ));
                        })),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 7, right: 7, bottom: 10),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: InkWell(
                            child: const Align(
                              child: Text('Create a Line',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black)),
                              alignment: Alignment.center,
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => createLine())),
                          ))),
                ),
                const SizedBox(height: 50)
              ]),
        ));
  }

  Scaffold createLine() {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: text_color),
          backgroundColor: backGround,
          title: const Text(
            'Host a Line',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 24,
              color: text_color,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Name:',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Theme.of(context).primaryColor,
                        filled: true),
                  ),
                  const SizedBox(height: 50),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Limit:',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      )),
                  const SizedBox(height: 10),
                  TextField(
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Theme.of(context).primaryColor,
                        filled: true),
                  ),
                  const SizedBox(height: 150),
                  TextButton(
                    child: const Text('Host Line',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'Open Sans')),
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    // todo: CREATE LINE FUNCTION
                    onPressed: null,
                  )
                ])));
  }
}
