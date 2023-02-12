import 'package:mobile_frontend/common/classes/solde.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SoldeService {

  static Future<Solde> findMySolde() async {
    String URI = "/solde/";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      Solde solde = Solde.map(body);
      return solde;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<void> createDebitOperation(double amount) async {
    String URI = "/solde/debit/${amount}";

    http.Response response = await BackEnd.getSimple(URI);
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