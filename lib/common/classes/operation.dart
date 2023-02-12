import 'ordered_item.dart';

class Operation {

  int? id;
  double? amount;
  String? description;
  DateTime? creationDate;
  String? type;
  String? status;

  List<StatusHistory>? statusHistories;

  static Operation map(data) {
    Operation operation = new Operation();

    operation.id           = data["id"];
    operation.amount       = data["amount"];
    operation.creationDate = DateTime.parse(data["creationDate"]);
    operation.description  = data["description"];
    operation.type         = data["type"];
    operation.status       = data["currentStatus"];

    operation.statusHistories = [];
    int length = data["statusHistories"].length;

    for(int i = 0; i < length; ++i) {
      StatusHistory statusHistory = new StatusHistory();
      statusHistory.status = data["statusHistories"][i]["status"];
      statusHistory.description = data["statusHistories"][i]["description"];
      statusHistory.statusDate = DateTime.parse(data["statusHistories"][i]["statusDate"]);

      operation.statusHistories!.add(statusHistory);
    }

    return operation;
  }
}