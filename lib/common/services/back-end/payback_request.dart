import 'package:http/http.dart' as http;
import 'package:mobile_frontend/common/classes/payback_request.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';
import 'dart:convert';

class PaybackRequestService {

  static Future<PaybackRequest> submit() async {
    String URI = "/payback/submit/";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return PaybackRequest.map(body);
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<PaybackRequest> listOne(int paybackRequestId) async {
    String URI = "/payback/find/${paybackRequestId}/";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return PaybackRequest.map(body);
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<PaybackRequest>> listAll() async {
    String URI = "/payback/";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return PaybackRequest.mapAll(body);
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

}