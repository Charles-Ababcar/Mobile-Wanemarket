import 'package:intl/intl.dart';

class OrderedItem {

  int? id;
  String? itemName;
  String? itemDescription;
  String? currentStatus;
  String? instructions;
  double? price;
  int? quantity;
  List<StatusHistory>? statusHistories;
  DateTime? creationDate;
  DateTime? deliveredDate;

  int? userId;
  String? username;

  static getList() {
    List<OrderedItem> orderedItems = [];

    for(int i = 0; i < 10; ++i) {
      OrderedItem orderedItem = new OrderedItem();
      orderedItem.id = i;
      orderedItem.itemDescription = "qzpfojeghgeoiherghiorg";
      orderedItem.currentStatus = "WAITING_FOR_RETURN";
      orderedItem.quantity = 5;
      orderedItems.add(orderedItem);
    }

    return orderedItems;
  }

  static OrderedItem? map(body) {
    OrderedItem orderedItem = new OrderedItem();

    orderedItem.id              = body["orderedItem"]["id"];

    if(body["orderedItem"]["itemName"] != null) {
      orderedItem.itemName        = body["orderedItem"]["itemName"];
    }

    orderedItem.itemDescription        = body["orderedItem"]["itemDescription"];
    orderedItem.currentStatus   = body["orderedItem"]["currentStatus"];
    orderedItem.price           = body["orderedItem"]["itemPrice"];
    orderedItem.quantity        = body["orderedItem"]["quantity"];
    orderedItem.userId          = body["orderedItem"]["userId"];
    orderedItem.username        = body["orderedItem"]["username"];
    orderedItem.instructions        = body["orderedItem"]["instructions"];
    orderedItem.creationDate  = DateTime.parse(body["orderedItem"]["creationDate"]);

    if(body["orderedItem"]["deliveredDate"] != null) {
      orderedItem.deliveredDate  = DateTime.parse(body["orderedItem"]["deliveredDate"]);
    }

    orderedItem.statusHistories = [];
    int length = body["orderedItem"]["statusHistories"].length;

    for(int i = 0; i < length; ++i) {
      StatusHistory statusHistory = new StatusHistory();
      statusHistory.status = body["orderedItem"]["statusHistories"][i]["status"];
      statusHistory.description = body["orderedItem"]["statusHistories"][i]["description"];
      statusHistory.statusDate = DateTime.parse(body["orderedItem"]["statusHistories"][i]["statusDate"]);

      orderedItem.statusHistories!.add(statusHistory);
    }
    return orderedItem;
  }

  static List<OrderedItem> mapAll(body) {
    int length = body["orderedItems"].length;

    List<OrderedItem> orderedItems = [];
    for(int i = 0; i < length; ++i) {
      OrderedItem orderedItem     = new OrderedItem();
      orderedItem.id              = body["orderedItems"][i]["id"];
      orderedItem.itemDescription = body["orderedItems"][i]["itemDescription"];
      orderedItem.itemName        = body["orderedItems"][i]["itemName"];
      orderedItem.currentStatus   = body["orderedItems"][i]["currentStatus"];
      orderedItem.price           = body["orderedItems"][i]["itemPrice"];
      orderedItem.quantity        = body["orderedItems"][i]["quantity"];
      orderedItem.instructions        = body["orderedItems"][i]["instructions"];
      orderedItem.creationDate  = DateTime.parse(body["orderedItems"][i]["creationDate"]);

      orderedItem.userId          = body["orderedItems"][i]["userId"];
      orderedItem.username        = body["orderedItems"][i]["username"];

      // if(body["orderedItems"][i]["deliveredDate"] != null) {
      //   orderedItem.deliveredDate  = DateTime.parse(body["orderedItems"][i]["deliveredDate"]);
      // }

      orderedItems.add(orderedItem);
    }

    return orderedItems;
  }

}

class StatusHistory {
  DateTime? statusDate;
  String? status;
  String? description;
}