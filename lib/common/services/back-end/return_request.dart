import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile_frontend/common/classes/return_request.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';

class ReturnRequestService {

  static Future<void> createReturnRequest(ReturnRequest request) async {
    String URI = "/ordered-item/return/request/";

    var data = {
      "reason"     : request.reason,
      "description": request.description,
      "orderedItem": {
        "id": request.orderedItemId
      }
    };

    http.Response response = await BackEnd.post(URI, data);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }

  }

}