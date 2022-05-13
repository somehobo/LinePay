import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:linepay/ApiCalling/ResponseObjects.dart';
import 'package:linepay/preferences/LinePayColors.dart';

// OFFERS PAGE CLASS
class OffersPage extends StatefulWidget {
  const OffersPage({Key? key, required this.userID, required this.lineID})
      : super(key: key);
  final int lineID;
  final String userID;

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  late Stream<LineDataResponse> _lineData;
  var _clockTimer;
  @override
  void initState() {
    super.initState();
    _lineData =
        Stream.fromFuture(getLineData(widget.lineID.toString(), widget.userID));
    _clockTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      _lineData = Stream.fromFuture(
          getLineData(widget.lineID.toString(), widget.userID));
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: text_color),
          backgroundColor: backGround,
          title: const Text(
            'Offers Page',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: text_color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Center(
                  child: Text(
                'Line Position: 10',
                style: const TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 34,
                  color: text_color,
                ),
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: _lineData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Uh-oh, Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    LineDataResponse offerData = snapshot.data;
                    return ListView.separated(
                      itemCount: offerData.offersToMe,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        return OfferCard();
                      },
                    );
                  }
                  return const Text('No offers to show',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 20,
                        color: text_color,
                      ));
                },
              ),
            ],
          ),
        ));
  }

  Widget OfferCard() {
    return Container(
        padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
        child: Container(
            height: 60,
            padding: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
                child: Align(
              child: Text(
                'dummy offer',
                style: const TextStyle(fontSize: 20),
              ),
              alignment: Alignment.centerLeft,
            ))));
  }
}
