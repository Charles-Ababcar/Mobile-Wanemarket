
import 'dart:convert';
import 'dart:developer';

import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';

class MarketplaceService {


  /**
   * create marketplaceRequest
   */
  static Future<void> sendMarketplaceRequest(Marketplace marketplace) async {
    
    var data = {
      "id"         : marketplace.id,
      "name"       : marketplace.name,
      "phone"      : marketplace.phone,
      "description": marketplace.description,
      "address"    : marketplace.address,
      "location": {
        "id": marketplace.location!.id
      }
    };

    http.Response response = await BackEnd.post("marketplace/create", data);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  /**
   * find marketplace sales by status
   */
  static Future<List<OrderedItem>> findSalesByStatus(String status) async {
    String URI = "/marketplace/ordered/list/${status}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    print(body);

    if (response.statusCode == 200) {
      List<OrderedItem> orderedItems = OrderedItem.mapAll(body);
      return orderedItems;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }


}