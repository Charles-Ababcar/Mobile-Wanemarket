

import 'dart:developer';

import 'package:mobile_frontend/common/classes/order.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderedItemService {

  /**
   * find specific orderedItem
   * for more details
   */
  static Future<OrderedItem?> findOrderedItemById(int orderedItemId) async {
    String URI = "/ordered-item/find/${orderedItemId}";

    print(URI);
    http.Response response = await BackEnd.getSimple(URI);

    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode == 200) {
      OrderedItem? orderedItem = OrderedItem.map(body);
      return orderedItem;
    } else if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<OrderedItem>?> findOrderedItemsByOrderId(int orderId) async {
    String URI = "/ordered-item/find/order/${orderId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode == 200) {
      List<OrderedItem> orderedItems = OrderedItem.mapAll(body);

      return orderedItems;
    } else if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  /**
   * set an orderedItem
   * available for shipment
   */
  static Future<void> setOrderedItemAvailable(int orderedItemId) async {
    String URI = "/marketplace/order/set/available/${orderedItemId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    inspect(body);

    if (response.statusCode == 200) {
      return;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  /**
   * set an orderedItem
   * returned validated
   */
  static Future<void> setOrderedItemReturned(int orderedItemId) async {
    String URI = "/marketplace/ordered/returned/${orderedItemId}";

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

  /**
   * find orderedItem
   * for current user (annonceur)
   */
  static Future<List<OrderedItem>> findPaidOrderedItems() async {
    String URI = "/ordered-item/latest/paid";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

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