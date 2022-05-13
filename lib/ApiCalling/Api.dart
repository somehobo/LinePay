import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// const linePayURL = "http://10.0.2.2:8000/";
const linePayURL = "http://127.0.0.1:8000/";

//Join Line
Future<JoinLineResponse> joinLine(String lineCode, String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'JoinLine/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'lineCode': lineCode, 'userID': userID}),
  );

  print(response.statusCode);
  if (response.statusCode == 201) {
    var joinLineResponse = JoinLineResponse.fromJson(jsonDecode(response.body));
    return joinLineResponse;
  } else {
    throw Exception('Failed to Join Line.');
  }
}

class JoinLineResponse {
  final String lineCode;
  final int lineID;
  final String userID;

  const JoinLineResponse(
      {required this.lineCode, required this.lineID, required this.userID});
  factory JoinLineResponse.fromJson(Map<String, dynamic> json) {
    return JoinLineResponse(
        lineCode: json['lineCode'],
        lineID: json['lineID'],
        userID: json['userID']);
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
  print(response.statusCode);
  if (response.statusCode == 201) {
    return LineDataResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

class LineDataResponse {
  final int position;
  final int offersToMe;
  final int offersFromMe;
  final List<int> positionsForSale;
  final String lineName;
  final bool positionForSale;
  final String lineCode;

  const LineDataResponse(
      {required this.position,
      required this.offersToMe,
      required this.offersFromMe,
      required this.positionsForSale,
      required this.lineName,
      required this.positionForSale,
      required this.lineCode});
  factory LineDataResponse.fromJson(Map<String, dynamic> json) {
    return LineDataResponse(
        position: json['position'],
        offersToMe: json['offersToMe'],
        offersFromMe: json['offersFromMe'],
        positionsForSale: json['positionsForSale'].cast<int>(),
        lineName: json['lineName'],
        positionForSale: json['positionForSale'],
        lineCode: json['lineCode']);
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
Future<LineDataResponse> authenticateLineUser(
    String email, String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL + 'LoginUser/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'lineID': email, 'userID': userID}),
  );
  if (response.statusCode == 201) {
    return LineDataResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Get Line Data.');
  }
}

class AuthenticateLineUserResponse {
  final String userID;

  const AuthenticateLineUserResponse({required this.userID});
  factory AuthenticateLineUserResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticateLineUserResponse(userID: json['userID']);
  }
}
