import 'package:intl/intl.dart';

class Order {
  int? id;
  DateTime? creationDate;
  double? itemsAmount;
  double? shipAmount;
  double? totalAmount;
  String? phone;
  String? address;
  String? instructions;

  String? status;

  static Order? map(body) {
    Order order = new Order();

    order.id = body["order"]["id"];
    order.creationDate = DateTime.parse(body["order"]["creationDate"]);
    order.itemsAmount  = body["order"]["itemsAmount"];
    order.shipAmount   = body["order"]["shipAmount"];
    order.totalAmount  = body["order"]["totalAmount"];
    order.address      = body["order"]["address"];
    order.phone        = body["order"]["phone"];
    order.instructions        = body["order"]["instructions"];
    order.status       = body["order"]["currentStatus"];

    return order;
  }

  static mapAll(data) {
    List<Order> orders = [];
    int length = data["orders"].length;

    for(int i = 0; i < length; ++i) {
      Order order = new Order();

      order.id = data["orders"][i]["id"];
      order.creationDate = DateTime.parse(data["orders"][i]["creationDate"]);
      order.itemsAmount = data["orders"][i]["itemsAmount"];
      order.shipAmount = data["orders"][i]["shipAmount"];
      order.totalAmount = data["orders"][i]["totalAmount"];
      order.status = data["orders"][i]["currentStatus"];

      orders.add(order);
    }

    return orders;
  }

}
