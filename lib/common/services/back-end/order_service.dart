import 'dart:developer';

import 'package:mobile_frontend/common/classes/order.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'dart:convert';

import 'package:mobile_frontend/common/services/back-end/service_backend.dart';

class OrderService {

  /**
   * check if we can pay an order
   */
  static Future<Order?> orderDetails(int orderId) async {
    String URI = "/order/find/${orderId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      Order? order = Order.map(body);
      return order;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  /**
   * check if we can pay an order
   */
  static Future<void> canPay(int orderId) async {
    String URI = "/order/can-pay/${orderId}";

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

  static Future<String?> paymentRequest(int orderId) async {
    String URI = "/order/payment-request/${orderId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode == 200) {
      String paymentUrl = body!["url"];
      return paymentUrl;
    } else if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  /**
   * validate lekket
   */
  static Future<Order?> validateLekket(Order order) async  {
    String URI = "/lekket/validate";

    var data;

    if(order.instructions == null) {
      data = {
        "phone"        : order.phone,
        "address"      : order.address
      };
    } else {
      data = {
        "phone"        : order.phone,
        "address"      : order.address,
        "instructions" : order.instructions
      };
    }

    http.Response response = await BackEnd.post(URI, data);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    print("error: ${body}");

    if(response.statusCode == 200) {
      Order? order = Order.map(body);
      inspect(order);
      return order;
    } else if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception("Response code: ${response.statusCode}");
    }
  }

  /**
   * check the status of order
   */
  static Future<String?> checkPaymentStatus(int orderId) async {
    String URI = "/payment/check/${orderId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode == 200) {
      String status = body!["status"];
      return status;
    } else if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<Order>?> findCustomerOrders() async {
    String URI = "/order/mine/";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode == 200) {
      List<Order> orders = Order.mapAll(body);
      return orders;
    } else if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

}