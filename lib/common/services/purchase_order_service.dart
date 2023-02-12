
import 'dart:convert';
import 'dart:developer';

import 'package:mobile_frontend/common/classes/article.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';

class LekketService {

  static Future <void> changeQuantity(int itemLekketId, int newQuantity) async {
    var URI = "lekket/quantity/edit/${itemLekketId}/${newQuantity}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(response.body);


    if (response.statusCode != 200) {

      if (response.statusCode == 400) {
        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }

    } 
  }

  static Future < List<ItemLekket>? > loadLekket() async {
    var URI = "lekket/mine";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(response.body);

    if (response.statusCode == 200) {
      List<ItemLekket> orders = ItemLekket.mapAll(body!["lekket"]);
      print("afterLoadAll");
      return orders;
      // return orders;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future <List<ItemLekket>?> addItem(int itemId, int quantity, String shoeSize, String clotheSize, String color, String? instructions) async {

    var URI = "lekket/";

    var data = {
      "quantity"         : quantity,
      "instructions"     : instructions == null ? null: instructions,
      "pickedShoeSize"   : shoeSize,
      "pickedClotheSize" : clotheSize,
      "pickedColor"      : color,
      "annonce": {
        "id": itemId
      }
    };


    http.Response response = await BackEnd.post(URI, data);
    Map? body = json.decode(response.body);

    if (response.statusCode != 200) {

      if (response.statusCode == 400) {
        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }
      // return orders;
    }

  }

  static Future <List<ItemLekket>?> edit(ItemLekket itemLekket) async {

    var URI = "lekket/${itemLekket.id}";

    var data = {
      "id": itemLekket.id,
      "quantity" : itemLekket.quantity,
      "pickedShoeSize"   : itemLekket.pickedShoeSize,
      "pickedClotheSize" : itemLekket.pickedClotheSize,
      "pickedColor"      : itemLekket.pickedColor,
      "instructions" : itemLekket.instructions == null ? null: itemLekket.instructions,
    };

    http.Response response = await BackEnd.post(URI, data);
    Map? body = json.decode(response.body);

    if (response.statusCode != 200) {

      if (response.statusCode == 400) {
        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }
      // return orders;
    }

  }


  static Future < List<ItemLekket>? > removeItem(int itemLekketId) async {
    var URI = "lekket/remove/${itemLekketId}";

    http.Response response = await BackEnd.getSimple(URI);

    Map? body = json.decode(response.body);

    if (response.statusCode != 200) {

      if (response.statusCode == 400) {

        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }
      // return orders;
    } 

  }
  
}