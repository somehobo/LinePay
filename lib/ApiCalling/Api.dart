import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const linePayURL = "http://10.0.2.2:8000/";

//Join Line

Future<JoinLineResponse> joinLine(String lineCode, String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL+'JoinLine/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'lineCode': lineCode,
      'userID': userID
    }),
  );
  print(response.statusCode);

  if(response.statusCode == 201) {
    return JoinLineResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Join Line.');
  }
}


class JoinLineResponse {
  final String lineCode;
  final int lineID;
  final int position;
  final String userID;

  const JoinLineResponse({
    required this.lineCode,
    required this.lineID,
    required this.position,
    required this.userID
  });
  factory JoinLineResponse.fromJson(Map<String, dynamic> json) {
    return JoinLineResponse(
        lineCode: json['lineCode'],
        lineID: json['lineID'],
        position: json['position'],
        userID: json['userID']
    );
  }
}

// Line Data

Future<LineDataResponse> getLineData(String lineID, String userID) async {
  final response = await http.post(
    Uri.parse(linePayURL+'GetLineData/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'lineID': lineID,
      'userID': userID
    }),
  );
  print(response.statusCode);
  if(response.statusCode == 201) {
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

  const LineDataResponse({
    required this.position,
    required this.offersToMe,
    required this.offersFromMe,
    required this.positionsForSale,
    required this.lineName,
    required this.positionForSale,
    required this.lineCode
  });
  factory LineDataResponse.fromJson(Map<String, dynamic> json) {
    return LineDataResponse(
        position: json['position'],
        offersToMe: json['offersToMe'],
        offersFromMe: json['offersFromMe'],
        positionsForSale: json['positionsForSale'].cast<int>(),
        lineName: json['lineName'],
        positionForSale: json['positionForSale'],
        lineCode: json['lineCode']
    );
  }
}

//toggle line for sale
Future<http.Response> toggleSale(String userID) async {
  return http.post(
    Uri.parse(linePayURL+'TogglePositionForSale/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userID': userID
    }),
  );
}

