import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linepay/ApiCalling/Api.dart';
import 'package:linepay/ApiCalling/ResponseObjects.dart';
import 'package:linepay/preferences/LinePayColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

import 'InQueue.dart';

class Qair<T1, T2, T3, T4> {
  final T1 position;
  final T2 price;
  final T3 offerID;
  final T3 index;

  Qair(this.position, this.price, this.offerID, this.index);
}

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
  var offers = [];
  var _clockTimer;

  linePattern(int index) {
    if (index.isEven) {
      return Theme.of(context).primaryColor;
    }
    return Theme.of(context).colorScheme.secondary;
  }

  @override
  initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      GetOffersResponse _getOffersResponse = await getOffers(widget.userID);
      var newOffersUnparsed = _getOffersResponse.amounts;
      var newOffersUnparsedLength = newOffersUnparsed.length;
      var newOffers = [];
      for (var i = 0; i < newOffersUnparsedLength; i++) {
        newOffers.add(Qair(
            _getOffersResponse.positions[i],
            _getOffersResponse.amounts[i],
            _getOffersResponse.offerIDs[i],
            i + 1));
      }
      Function eq = const ListEquality().equals;
      if (!eq(newOffers, offers)) {
        setState(() {
          offers = newOffers;
        });
      }
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
            'Offers to Me',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: text_color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: ListView(
            children:
                offers.map<Widget>((offer) => offerListing(offer)).toList()));
  }

  offerListing(Qair offer) {
    return Container(
        padding: EdgeInsets.only(top: 10, left: 7, right: 7),
        child: Container(
            height: 45,
            padding: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: linePattern(offer.index),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Text(
                  "     Line Position: " +
                      offer.position.toString() +
                      "   Price: " +
                      offer.price.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                Padding(padding: EdgeInsets.only(left: 15)),
                TextButton(
                    onPressed: () async {
                      var _offerResponse = await acceptOffer(offer.offerID.toString());
                      if (_offerResponse.accepted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Accept"))
              ],
            )));
  }
}
