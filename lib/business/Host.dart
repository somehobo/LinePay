import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:linepay/ApiCalling/ResponseObjects.dart';
import 'package:linepay/business/LineDetails.dart';
import 'package:linepay/preferences/LinePayColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// HOST PAGE CLASS
class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  final TextEditingController _lineNameController = TextEditingController();
  late final SharedPreferences _prefs;
  late final String _boID;
  late Stream<BusinessOwnerLines>? _lines;
  var _timer;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<void> getSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _boID = _prefs.getString('boID').toString();
    _lines = getBusinessOwnerLines(_boID).asStream();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      _lines = getBusinessOwnerLines(_boID).asStream();
    });
    print(_lines);
  }

  Widget lineCard(
      Map<String, int> linesMap, Map<String, int> lineIDs, int index) {
    String name = linesMap.keys.elementAt(index);
    int persons = linesMap.values.elementAt(index);
    int lineID = lineIDs[name]!;
    return Container(
        padding: const EdgeInsets.all(7),
        height: 50,
        decoration: BoxDecoration(
          color: (index % 2 == 0)
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(name, style: const TextStyle(fontSize: 22)),
            Text('People waiting: $persons',
                style: const TextStyle(fontSize: 22))
          ]),
          onTap: () => Navigator.push(
              (context),
              MaterialPageRoute(
                  builder: (context) => LineDetails(
                        lineName: name,
                        persons: persons,
                        lineID: lineID,
                      ))),
        ));
  }

  @override
  Widget build(BuildContext context) {
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
                        stream: _lines, //_hostData,
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
                            Map<String, int> linesMap =
                                Map<String, int>.from(snapshot.data.lines);
                            Map<String, int> lineIDs =
                                Map<String, int>.from(snapshot.data.lines);
                            // LINE CARD BUILDER
                            return ListView.separated(
                              itemCount: linesMap.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                return lineCard(linesMap, lineIDs, index);
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
                                    builder: (context) => createHostLine())),
                          ))),
                ),
                const SizedBox(height: 50)
              ]),
        ));
  }

  Scaffold createHostLine() {
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
                    controller: _lineNameController,
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
                    // controller: _lineLimitController,
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
                    onPressed: () {
                      if (_lineNameController.text.isEmpty) {
                        print("lineNameController is empty");
                        null;
                      } else {
                        createLine(_lineNameController.text, _boID);
                        Navigator.pop(context);
                      }
                    },
                  )
                ])));
  }
}
