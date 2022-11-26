import 'package:intl/intl.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';

class PaybackRequest {

  int? id;
  String? currentStatus;
  double? totalAmount;
  double? wanemarketPourcentage;
  double? annonceurPourcentage;
  double? pourcentage;
  DateTime? creationDate;
  List<OrderedItem>? sales = [];
  List<StatusHistory>? histories = [];

  static map(body) {
    PaybackRequest paybackRequest = new PaybackRequest();

    paybackRequest.id                    = body["paybackRequest"]["id"];
    paybackRequest.currentStatus         = body["paybackRequest"]["currentStatus"];
    paybackRequest.totalAmount           = body["paybackRequest"]["totalAmount"];
    paybackRequest.wanemarketPourcentage = body["paybackRequest"]["wanemarketPourcentage"];
    paybackRequest.annonceurPourcentage  = body["paybackRequest"]["annonceurPourcentage"];
    paybackRequest.pourcentage           = body["paybackRequest"]["pourcentageUsed"];
    paybackRequest.creationDate          = DateTime.parse(body["paybackRequest"]["creationDate"]);

    // status history
    int historiesLength = body["paybackRequest"]["statusHistories"].length;
    for(int i = 0; i < historiesLength; ++i) {
      StatusHistory statusHistory = new StatusHistory();
      statusHistory.status        = body["paybackRequest"]["statusHistories"][i]["status"];
      statusHistory.description   = body["paybackRequest"]["statusHistories"][i]["description"];
      statusHistory.statusDate    = DateTime.parse(body["paybackRequest"]["statusHistories"][i]["statusDate"]);
      paybackRequest.histories!.add(statusHistory);
    }

    // status history
    int salesLength = body["paybackRequest"]["sales"].length;
    for(int i = 0; i < salesLength; ++i) {
      OrderedItem sale = new OrderedItem();
      sale.itemName = body["paybackRequest"]["sales"][i]["itemName"];
      sale.itemDescription = body["paybackRequest"]["sales"][i]["itemDescription"];
      sale.price           = body["paybackRequest"]["sales"][i]["itemPrice"];
      sale.quantity        = body["paybackRequest"]["sales"][i]["quantity"];
      sale.username        = body["paybackRequest"]["sales"][i]["username"];
      sale.creationDate    = DateTime.parse(body["paybackRequest"]["sales"][i]["creationDate"]);
      paybackRequest.sales!.add(sale);
    }

    return paybackRequest;
  }

  static mapAll(body) {
    List<PaybackRequest> paybackRequests = [];
    int length = body["paybackRequests"].length;

    for(int i = 0; i < length; ++i) {
      PaybackRequest paybackRequest = new PaybackRequest();
      paybackRequest.id                    = body["paybackRequests"][i]["id"];
      paybackRequest.currentStatus         = body["paybackRequests"][i]["currentStatus"];
      paybackRequest.totalAmount           = body["paybackRequests"][i]["totalAmount"];
      paybackRequest.wanemarketPourcentage = body["paybackRequests"][i]["wanemarketPourcentage"];
      paybackRequest.annonceurPourcentage  = body["paybackRequests"][i]["annonceurPourcentage"];
      paybackRequest.pourcentage           = body["paybackRequests"][i]["pourcentage"];
      paybackRequest.creationDate          = DateTime.parse(body["paybackRequests"][i]["creationDate"]);

      paybackRequests.add(paybackRequest);
    }

    return paybackRequests;
  }

  static List<PaybackRequest> generate() {

    var now = new DateTime.now();

    return [
    ];

  }

}