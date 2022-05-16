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

class userResponse {
  final String userID;
  final int lineID;

  const userResponse({required this.userID, required this.lineID});
  factory userResponse.fromJson(Map<String, dynamic> json) {
    return userResponse(userID: json['userID'], lineID: json['lineID']);
  }
}

class BusinessOwnerLines {
  final Map<dynamic, dynamic>? lines;
  final Map<dynamic, dynamic>? lineIDs;

  const BusinessOwnerLines({required this.lines, required this.lineIDs});
  factory BusinessOwnerLines.fromJson(
      Map<dynamic, Map<dynamic, dynamic>> json) {
    print(json);
    return BusinessOwnerLines(
      lines: json['lines'], 
      lineIDs: json['lineIDs']);
  }
}

class CreateBusinessResponse {
  final String bID; //businessID

  const CreateBusinessResponse({required this.bID});
  factory CreateBusinessResponse.fromJson(Map<String, dynamic> json) {
    return CreateBusinessResponse(bID: json['business-ID']);
  }
}

class CreateLineResponse {
  final String lineID;

  const CreateLineResponse({required this.lineID});
  factory CreateLineResponse.fromJson(Map<String, dynamic> json) {
    return CreateLineResponse(lineID: json['lineID']);
  }
}

class GetOffersResponse {
  //offers[0] is offer amount
  //offers[1] is current position of the person that offered
  //offers[2] is the made to id, useless
  final List<List<int>> offers; //businessID

  const GetOffersResponse({required this.offers});
  factory GetOffersResponse.fromJson(Map<String, dynamic> json) {
    return GetOffersResponse(offers: json['offers']);
  }
}
