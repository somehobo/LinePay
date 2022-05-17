import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'ResponseObjects.dart';

// const linePayURL = "http://10.0.2.2:8000/";
const linePayURL = "http://127.0.0.1:8000/";
// const linePayURL = "http://35.230.23.243/";

Future<void> nextInLineBox(context) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('You are ready to be seated!'),
            content: const Text('Please come to the front desk'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MyApp())),
                  child: const Text('Ok'))
            ],
          ));
}

//Join Line
Future<JoinLineResponse> joinLineAuthenticated(
    String lineCode, String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'JoinLine/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'lineCode': lineCode, 'userID': userID}),
  );

  if (response.statusCode == 201) {
    var joinLineResponse = JoinLineResponse.fromJson(jsonDecode(response.body));
    return joinLineResponse;
  } else {
    throw Exception('Failed to Join Line.');
  }
}

Future<JoinLineResponse> joinLine(String lineCode) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'JoinLine/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'lineCode': lineCode, 'userID': "-1"}),
  );
  if (response.statusCode == 201) {
    var joinLineResponse = JoinLineResponse.fromJson(jsonDecode(response.body));
    return joinLineResponse;
  } else {
    throw Exception('Failed to Join Line.');
  }
}

// Line Data
Future<LineDataResponse> getLineData(String lineID, String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'GetLineData/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'lineID': lineID, 'userID': userID}),
  );
  if (response.statusCode == 201) {
    return LineDataResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

//toggle line for sale
Future<http.Response> toggleSale(String userID) async {
  return http.post(
    Uri.parse(linePayURL + 'TogglePositionForSale/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'userID': userID}),
  );
}

//authenticate in line user
Future<userResponse> authenticateLineUser(String email, String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'LoginUser/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'userID': userID}),
  );
  if (response.statusCode == 201) {
    return userResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

//create business owner, on success returns the business owner's ID
//logs in the owner if they ALREADY EXIST as well
Future<userResponse> createBusinessOwner(String email) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'CreateBusinessOwner/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email}),
  );
  if (response.statusCode == 201) {
    return userResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

Future<BusinessOwnerLines> getBusinessOwnerLines(String boID) async {
  final response =
      await http.post(Uri.parse(linePayURL + 'getBusinessOwnerLines/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'boID': boID}));
  if (response.statusCode == 201) {
    return BusinessOwnerLines.fromJson(
        Map<String, Map<String, dynamic>>.from(jsonDecode(response.body)));
    // return BusinessOwnerLines.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Business Owner Data.');
  }
}

Future<void> createLine(String name, String businessOwner) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'CreateLine/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'name': name, 'businessOwner': businessOwner}),
  );
  if (response.statusCode == 201) {
    return;
    // return CreateLineResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create Line.');
  }
}

Future<GetOffersResponse> getOffers(String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'GetOffers/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'userID': userID}),
  );
  if (response.statusCode == 201) {
    return GetOffersResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

Future<AcceptOfferResponse> acceptOffer(String offerID) async {
  final response = await http.post(
    Uri.parse(linePayURL+'AcceptOffer/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'offerID': offerID
    }),
  );
  if(response.statusCode == 201) {
    return AcceptOfferResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

Future<GetOffersResponse> leaveLine(String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'leaveLine/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'userID': userID}),
  );
  if (response.statusCode == 201) {
    return GetOffersResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

Future<AcceptOfferResponse> CreateOffer(String userID, String position, String amount) async {
  final response = await http.post(
    Uri.parse(linePayURL+'CreateOffer/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userID': userID,
      'positions': position,
      'amount': amount
    }),
  );
  if(response.statusCode == 201) {
    return AcceptOfferResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

//next is NEXT IN LINE





